<?php
// src/Projects/SocialSportsBundle/Utils/RandomSequenceGenerator.php
namespace Projects\SocialSportsBundle\Utils;

class RandomSequenceGenerator
{
    // random seed
    private static $RSeed = 0;

    // set seed
    public static function seed($s = 0)
    {
        self::$RSeed = abs(intval($s)) % 9999999 + 1;
        self::num();
    }

    // generate random number
    public static function num($min = 0, $max = 9999999)
    {
        if (self::$RSeed == 0) self::seed(mt_rand());
        self::$RSeed = (self::$RSeed * 125) % 2796203;
        return self::$RSeed % ($max - $min + 1) + $min;
    }

    // generate random number sequence
    public static function sequence($nbOccurence, $min = 0, $max = 9999999)
    {
        $result = array();
        for ($i = 0; $i < $nbOccurence; $i++) {
            $result[] = self::num($min, $max);
        }

        return $result;
    }
}