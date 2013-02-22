<?php
// src/Projects/SocialSportsBundle/Entity/Player.php
namespace Projects\SocialSportsBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use Projects\SocialSportsBundle\Entity\People;
use Projects\SocialSportsBundle\Utils\RandomSequenceGenerator;
use Projects\SocialSportsBundle\Utils\NumberUtils;

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

    /**
     * [initializeFromFacebookUser description]
     * @param  Array $facebookUser the facebook profile of a facebook user, sent by GraphAPI
     * @param  People $people A People object, which nis linked tot hte same facebookId as the $facebookUser
     */
    public function initializeFromFacebookUser($facebookUser, $people)
    {
        $this->facebookId = $facebookUser['id'];
        $this->people = $people;
        $this->level = 0;

        RandomSequenceGenerator::seed(intval(substr($this->facebookId, -9)));

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
        $physicalAttributes = $this->getVectorOfNumber($totalPhysicalAttributesPoints, $physicalMinAttribute, $physicalMaxAttribute, 10);
        $mentalAttributes = $this->getVectorOfNumber($totalMentalAttributesPoints, $mentalMinAttribute, $mentalMaxAttribute, 10);

        $this->attributes = array_merge($physicalAttributes, $mentalAttributes);
    }

    // This function is not working perfectly, since the generation of random numbers in the first for loop, can leave a total too low to get good numbers in the splitTotalInTwo call
    // But it's working fine for a size of 10, and th'at's all I need right now
    private function getVectorOfNumber($total, $minValue, $maxValue, $size = 10)
    {
        $result = array();
        $result[] = $minValue;
        $total -= $minValue;
        $result[] = $maxValue;
        $total -= $maxValue;
        $previousPowerofTwo = NumberUtils::getPreviousPowerOfTwo($size-2);
        for ($i = $previousPowerofTwo; $i < $size-2; $i++)
        {
            $rand = RandomSequenceGenerator::num($minValue, $maxValue);
            $total -= $rand;
            $result[] = $rand;
        }

        $otherResults = $this->splitTotalInTwo($total, $minValue, $maxValue, $previousPowerofTwo/2, 1, 0.5);
        $l = sizeof($otherResults);
        for ($i = 0; $i < $l; $i++)
        {
            $result[] = $otherResults[$i];
        }

        shuffle($result);
        return $result;
    }

    /**
     * This function split a unique number into many numbers whose total equals to the one given as a parameter.
     * The function only works for size equals to a power of 2, but I think it can be easily done for any size,
     * by making as many "power of 2" calls as necessary to get a good final result.
     * @param  int $total The expected value of the sum of the resulting numbers
     * @param  int $minValue The minimum value each number can take
     * @param  int $maxValue The maximum value each number can take
     * @param  int $size The number of numbers we want to split the total into
     * @param  int $stepNum The step number of the recursive calls. Used to enhance the results of the algorithm.
     * @param  float $balanceFactor this is the ratio used to make the first steps of the recursive calls, less important that they would be without it. It MUST be < 0.5
     * @return
     */
    private function splitTotalInTwo($total, $minValue, $maxValue, $size, $stepNum, $balanceFactor)
    {
        $result = array();

        // we determine the min and max values allowed for the random generated number so that it doesn't
        // make the second group impossible to process with success
        $minRand = max($size * $minValue, $total - ($size * $maxValue));
        $maxRand = min($size * $maxValue, $total - ($size * $minValue));

        // the balanceFactor is used to make the split tighter in the early stages of the recursive algorithm,
        // therefore ensuring a best number distribution in the end.
        // You can comment the next three lines to see the number distribution of th inital algorithm.
        // You can alsocchange the balancefactor to get which results you like most.
        // This var good also be passed as parameter to fine tune the algorithm a little bit more.
        $delta = floor(($maxRand - $minRand) * ($balanceFactor / $stepNum));
        $minRand += $delta;
        $maxRand -= $delta;

        $random = RandomSequenceGenerator::num($minRand, $maxRand);
        if ($size > 1)
        {
            $result = array_merge($this->splitTotalInTwo($random, $minValue, $maxValue, $size / 2, $stepNum+1, RandomSequenceGenerator::num(0, 100)*$balanceFactor/100),
                $this->splitTotalInTwo($total - $random, $minValue, $maxValue, $size / 2, $stepNum+1, RandomSequenceGenerator::num(0, 100)*$balanceFactor/100)
            );
        }
        else
        {
            $result[] = $random;
            $result[] = $total - $random;
        }

        return $result;
    }
}
