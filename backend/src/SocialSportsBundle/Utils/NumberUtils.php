<?php
namespace Projects\SocialSportsBundle\Utils;

class NumberUtils
{
    /**
     * This function returns the nearest power of two number, which is lower than the number given as parameter.
     * This is a very simple function, which is not optimized, so it is to be used only with small numbers
     * @param  int $num The number from which we wqnt to get the nearest power of two number
     * @return int      A power of two integer which is the closest to the one given as a parameter, while being lower
     */
    public static function getPreviousPowerOfTwo($num)
    {
        $i = 0;
        while(pow(2, $i) <= $num)
        {
            $i++;
        }
        return pow(2, ($i-1));
    }
}
