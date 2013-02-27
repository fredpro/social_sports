<?php

namespace Projects\SocialSportsBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Response;
use Projects\SocialSportsBundle\Entity\Manager;
use Projects\SocialSportsBundle\Entity\People;
use Projects\SocialSportsBundle\Entity\Player;
use Projects\SocialSportsBundle\Utils\RandomSequenceGenerator;
use Projects\SocialSportsBundle\Utils\NumberUtils;

class UserController extends Controller
{
    //--------------------------------------------------------------------
    // CONSTANTS
    //--------------------------------------------------------------------

    const INITIAL_NUMBER_OF_UNLOCKED_PLAYERS = 11;

    //--------------------------------------------------------------------
    // PUBLIC METHODS
    //--------------------------------------------------------------------

    public function getManagerProfileAction($facebookUser, $facebookFriends)
    {
        $facebookId = $facebookUser['id'];
        $em = $this->getDoctrine()->getManager();

        // now we check if a manager entry exist
        $manager = $em->getRepository('ProjectsSocialSportsBundle:Manager')
            ->find($facebookId);

        if ($manager)
        {
            // this user already has a manager profile
            // we just get what we need for the game
        }
        else
        {
           // this user is new
           // we have to create his profile
           $manager = $this->createManagerProfile($facebookUser, $facebookFriends['data']);
        }

        $em->flush();

        $response = new Response(json_encode(
            array(
                'name' => $facebookUser['name'],
                'unlockedPlayers' => $manager->getUnlockedPlayers()
            )
        ));
        $response->headers->set('Content-Type', 'application/json');
        return $response;
    }

    //--------------------------------------------------------------------
    // PRIVATE METHODS
    //--------------------------------------------------------------------

    private function createPeopleProfile($facebookUser)
    {
        $people = new People();

        $em = $this->getDoctrine()->getManager();
        $people->setFacebookId($facebookUser['id']);
        $people->setNickname('');
        $em->persist($people);

        return $people;
    }

    private function createManagerProfile($facebookUser, $facebookFriends)
    {
        $manager = new Manager();

        $em = $this->getDoctrine()->getManager();

        // check if the user entry already exist in the people table
        $people = $em->getRepository('ProjectsSocialSportsBundle:People')
            ->find($facebookUser['id']);
        if ($people)
        {
            // this user already has a people entry
            // we just get what we need for the game
        }
        else
        {
           // this user is totally new
           // we have to create his people entry
           $people = $this->createPeopleProfile($facebookUser);
        }

        $manager->setFacebookId($people->getFacebookId());
        $manager->setPeople($people);
        $manager->setXp(0);
        $manager->setLevel(0);
        $manager->setCoins(0);
        $lockedPlayers = array();
        $unlockedPlayers = array();

        // first we put the user's player as the first entry in the lockedPlayers array
        $player =  $em->getRepository('ProjectsSocialSportsBundle:Player')
            ->find($manager->getFacebookId());
        if ($player)
        {
            // the player already exist, we just have to put him in the locked or unlocked friends array
        }
        else
        {
            // then we create the player
            $player = $this->createPlayerProfile($facebookUser, $people);
        }

        // if the user has not enough friends to fill the initial number of unlockedPlayers, we put the user in the unlockedPlayers array
        if (sizeof($facebookFriends) < self::INITIAL_NUMBER_OF_UNLOCKED_PLAYERS)
        {
            $unlockedPlayers[] = $player->getFacebookId();
        }
        // else, we put him as the first entry in the lockedPlayers array
        else
        {
            $lockedPlayers[] = $player->getFacebookId();
        }

        // now we create a player for each one of the manager's friends
        shuffle($facebookFriends);
        foreach ($facebookFriends as $friend)
        {
            $player =  $em->getRepository('ProjectsSocialSportsBundle:Player')
                ->find($friend['id']);
            if ($player)
            {
                // the player already exist, we just have to put him in the locked or unlocked friends array
            }
            else
            {
                // then we create the player
                $player = $this->createPlayerProfile($friend);
            }
            if (sizeof($unlockedPlayers) < self::INITIAL_NUMBER_OF_UNLOCKED_PLAYERS)
            {
                $unlockedPlayers[] = $player->getFacebookId();
            }
            else
            {
                $lockedPlayers[] = $player->getFacebookId();
            }
        }

        $manager->setUnlockedPlayers($unlockedPlayers);
        $manager->setLockedPlayers($lockedPlayers);
        $em->persist($manager);

        return $manager;
    }

    private function createPlayerProfile($facebookUser)
    {
        $player = new Player();

        $em = $this->getDoctrine()->getManager();

        // the player doesn't exist, we have to create it
        // first check if the user entry already exist in the people table
        $people = $em->getRepository('ProjectsSocialSportsBundle:People')
            ->find($facebookUser['id']);
        if ($people)
        {
            // this user already has a people entry
            // we just get what we need for the game
        }
        else
        {
           // this user is totally new
           // we have to create his people entry
           $people = $this->createPeopleProfile($facebookUser);
        }

        $player->setFacebookId($people->getFacebookId());
        $player->setPeople($people);
        $player->setLevel(0);

        RandomSequenceGenerator::seed(intval(substr($player->getFacebookId(), -9)));

        // we create the attributes following the algorithm defined in the GDD.
        // we set the starting totals based on user's gender
        if (isset($facebookUser['gender']))
        {
            $isMale = ($facebookUser['gender'] == 'male');
        }
        else
        {
            $isMale = (RandomSequenceGenerator::num(1, 2) == 1);
        }

        $totalPhysicalAttributesPoints = ($isMale) ? 550 : 450;
        $totalMentalAttributesPoints = ($isMale) ? 450 : 550;

        // then we modify them based on the user's age
        if (isset($facebookUser['birthday']))
        {
            $birthdayElems = explode('/', $facebookUser['birthday']);
            $birthYear = intval($birthdayElems[sizeof($birthdayElems)-1]);
            $age = intval(date('Y')) - $birthYear;
        }
        else
        {
            $age = 30;
        }

        if ($age <= 20)
        {
            $totalPhysicalAttributesPoints += 100;
            $totalMentalAttributesPoints -= 100;
        }
        else if ($age > 20 && $age < 30)
        {
            $totalPhysicalAttributesPoints += (30 - $age) * 10;
            $totalMentalAttributesPoints -= (30 - $age) * 10;
        }
        else if ($age == 30)
        {
            // we do nothing it's the most balanced profile
        }
        else if ($age > 30 && $age < 50)
        {
            $totalPhysicalAttributesPoints -= ($age - 30) * 5;
            $totalMentalAttributesPoints += ($age - 30) * 5;
        }
        else if ($age >= 50)
        {
            $totalPhysicalAttributesPoints -= 100;
            $totalMentalAttributesPoints += 100;
        }

        // then we add or remove a random number between 0 and 10 %
        $randomPercentage = RandomSequenceGenerator::num(0, 20) - 10;
        $totalPhysicalAttributesPoints += $randomPercentage * 1000 / 100;
        $totalMentalAttributesPoints -= $randomPercentage * 1000 / 100;

        // now we set the min and max values for both categories
        $averagePhysicalattribute = floor($totalPhysicalAttributesPoints/10);
        $physicalMaxAttribute = RandomSequenceGenerator::num(min(90, $averagePhysicalattribute+10), min(90, $averagePhysicalattribute+30));
        $physicalMinAttribute = RandomSequenceGenerator::num(max(10, $averagePhysicalattribute-40), max(10, $averagePhysicalattribute-20));
        $averageMentalattribute = floor($totalMentalAttributesPoints/10);
        $mentalMaxAttribute = RandomSequenceGenerator::num(min(90, $averageMentalattribute+10), min(90, $averageMentalattribute+30));
        $mentalMinAttribute = RandomSequenceGenerator::num(max(10, $averageMentalattribute-40), max(10, $averageMentalattribute-20));

        //Finally we set the ten values of each categories based on a sequence of random numbers generated from the user's facebook id.
        $physicalAttributes = NumberUtils::getVectorOfNumber($totalPhysicalAttributesPoints, $physicalMinAttribute, $physicalMaxAttribute, 10);
        $mentalAttributes = NumberUtils::getVectorOfNumber($totalMentalAttributesPoints, $mentalMinAttribute, $mentalMaxAttribute, 10);

        $player->setAttributes(array_merge($physicalAttributes, $mentalAttributes));

        $em->persist($player);

        return $player;
    }
}
