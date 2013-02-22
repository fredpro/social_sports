<?php

namespace Projects\SocialSportsBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Response;
use Projects\SocialSportsBundle\Entity\Manager;
use Projects\SocialSportsBundle\Entity\People;

class UserController extends Controller
{
    public function getUserProfileAction($facebookUser, $facebookFriends)
    {
        $facebookId = $facebookUser['id'];
        $em = $this->getDoctrine()->getManager();

        // check if the user entry already exist in the people table
        $people = $em->getRepository('ProjectsSocialSportsBundle:People')
            ->find($facebookId);
        if ($people)
        {
            // this user already has a people entry
            // we just get what we need for the game
        }
        else
        {
           // this user is totally new
           // we have to create his people entry
           $people = new People();
           $people->initializeFromFacebookUser($facebookUser);
           $em->persist($people);
        }

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
           $manager = new Manager();
           $manager->initializeFromFacebookUser($facebookUser, $people, $facebookFriends['data'], $em);
           $em->persist($manager);
        }

        $em->flush();

        return $this->render('ProjectsSocialSportsBundle:User:profile.html.twig',
            array(
                'name' => $facebookUser['name'],
                'unlockedPlayers' => $manager->getUnlockedPlayers()
            )
        );
    }
}
