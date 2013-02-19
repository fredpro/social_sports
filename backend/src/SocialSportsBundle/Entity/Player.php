<?php
// src/Projects/SocialSportsBundle/Entity/Player.php
namespace Projects\SocialSportsBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use Projects\SocialSportsBundle\Entity\People;
use Projects\SocialSportsBundle\Utils\RandomSequenceGenerator;

/**
 * @ORM\Entity(repositoryClass="Projects\SocialSportsBundle\Entity\PlayerRepository")
 * @ORM\Table(name="player")
 */
class Player
{

    //--------------------------------------------------------------------
    // ATTRIBUTES
    //--------------------------------------------------------------------

    /**
     * @ORM\Id
     * @ORM\Column(name="facebook_id", length=45)
     */
    protected $facebookId;

    /**
     * @ORM\OneToOne(targetEntity="People")
     * @ORM\JoinColumn(name="people_id", referencedColumnName="facebook_id")
     **/
    protected $people;

    /**
     * @ORM\Column(type="smallint")
     */
    protected $level;

    /**
     * @ORM\Column(type="json_array")
     */
    protected $attributes;

    //--------------------------------------------------------------------
    // GETTERS AND SETTERS
    //--------------------------------------------------------------------

    /**
     * Set level
     *
     * @param integer $level
     * @return Player
     */
    public function setLevel($level)
    {
        $this->level = $level;

        return $this;
    }

    /**
     * Get level
     *
     * @return integer
     */
    public function getLevel()
    {
        return $this->level;
    }

    /**
     * Set attributes
     *
     * @param array $attributes
     * @return Player
     */
    public function setAttributes($attributes)
    {
        $this->attributes = $attributes;

        return $this;
    }

    /**
     * Get attributes
     *
     * @return array
     */
    public function getAttributes()
    {
        return $this->attributes;
    }

    /**
     * Set people
     *
     * @param \Projects\SocialSportsBundle\Entity\People $people
     * @return Player
     */
    public function setPeople(\Projects\SocialSportsBundle\Entity\People $people = null)
    {
        $this->people = $people;

        return $this;
    }

    /**
     * Get people
     *
     * @return \Projects\SocialSportsBundle\Entity\People
     */
    public function getPeople()
    {
        return $this->people;
    }

    /**
     * Set facebookId
     *
     * @param string $facebookId
     * @return Player
     */
    public function setFacebookId($facebookId)
    {
        $this->facebookId = $facebookId;

        return $this;
    }

    /**
     * Get facebookId
     *
     * @return string
     */
    public function getFacebookId()
    {
        return $this->facebookId;
    }

    //--------------------------------------------------------------------
    // PUBLIC METHODS
    //--------------------------------------------------------------------

    public function initializeFromFacebookUser($facebookUser, $people)
    {
        $this->facebookId = $facebookUser['id'];
        $this->people = $people;
        $this->level = 0;

        // we create the attributes following the algorithm defined in the GDD.
        // we set the starting totals based on user's gender
        $isMale = ($facebookUser->gender == 'male');

        $totalPhysicalAttributesPoints = ($isMale) ? 550 : 450;
        $totalMentalAttributesPoints = ($isMale) ? 450 : 550;

        // then we modify them based on the user's age
        if ($facebookUser->birthday)
        {
            $birthdayElems = explode('/', $facebookUser->birthday);
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

        RandomSequenceGenerator::seed(intval(substr($this->facebookId, -9)));
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
        $physicalAttributes = array();
        $physicalAttributes[] = $physicalMinAttribute;
        $physicalAttributesRandomSequence = RandomSequenceGenerator::sequence(10, 0, 100);
        sort($physicalAttributesRandomSequence);
        $maxNum = $physicalAttributesRandomSequence[sizeof($physicalAttributesRandomSequence)-1];
        $minNum = $physicalAttributesRandomSequence[0];
        $range = $maxNum - $minNum;
        $total = $physicalMinAttribute;
        $l = sizeof($physicalAttributesRandomSequence)-2; // we go up to size -2, because the highest value has been calculated,
                                                          //and the second highest value will get the remaining number of points, to we have the right total of points
        for ($i = 1; $i < $l; $i++) // we start from 1 because the lowest value has already been calculated
        {
            $num = $physicalAttributesRandomSequence[$i];
            $ratio = ($num - $minNum) / ($maxNum - $minNum);
            $newAttributeValue = floor($ratio * ($physicalMaxAttribute - $physicalMinAttribute)) + $physicalMinAttribute;
            $physicalAttributes[] = $newAttributeValue;
            $physicalMinAttribute = $newAttributeValue;
            $minNum = $num;
            $total += $newAttributeValue;
        }
        // now we set the second highest value to the remaining number of points
        $physicalAttributes[] = $totalPhysicalAttributesPoints - $total - $physicalMaxAttribute;

        $physicalAttributes[] = $physicalMaxAttribute;

        // now, we do the same for the mental attributes
        $mentalAttributes = array();
        $mentalAttributes[] = $mentalMinAttribute;
        $mentalAttributesRandomSequence = RandomSequenceGenerator::sequence(10, 0, 100);
        sort($mentalAttributesRandomSequence);
        $maxNum = $mentalAttributesRandomSequence[sizeof($mentalAttributesRandomSequence)-1];
        $minNum = $mentalAttributesRandomSequence[0];
        $range = $maxNum - $minNum;
        $total = $mentalMinAttribute;
        $l = sizeof($mentalAttributesRandomSequence)-2; // we go up to size -2, because the highest value has been calculated,
                                                          //and the second highest value will get the remaining number of points, to we have the right total of points
        for ($i = 1; $i < $l; $i++) // we start from 1 because the lowest value has already been calculated
        {
            $num = $mentalAttributesRandomSequence[$i];
            $ratio = ($num - $minNum) / ($maxNum - $minNum);
            $newAttributeValue = floor($ratio * ($mentalMaxAttribute - $mentalMinAttribute)) + $mentalMinAttribute;
            $mentalAttributes[] = $newAttributeValue;
            $mentalMinAttribute = $newAttributeValue;
            $minNum = $num;
            $total += $newAttributeValue;
        }
        // now we set the second highest value to the remaining number of points
        $mentalAttributes[] = $totalMentalAttributesPoints - $total - $mentalMaxAttribute;

        $mentalAttributes[] = $mentalMaxAttribute;

        $this->attributes = array_merge($physicalAttributes, $mentalAttributes);
    }
}
