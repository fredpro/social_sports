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

    // This function is not working perfectly, since the generation of random numbers in the first for loop, can leave a total too low to get good numbers in the splitTotalInTwo call
    // But it's working fine for a size of 10, and th'at's all I need right now
    public static function getVectorOfNumber($total, $minValue, $maxValue, $size = 10)
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

        $otherResults = NumberUtils::splitTotalInTwo($total, $minValue, $maxValue, $previousPowerofTwo/2, 1, 0.5);
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
    public static function splitTotalInTwo($total, $minValue, $maxValue, $size, $stepNum, $balanceFactor)
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
            $result = array_merge(NumberUtils::splitTotalInTwo($random, $minValue, $maxValue, $size / 2, $stepNum+1, RandomSequenceGenerator::num(0, 100)*$balanceFactor/100),
                NumberUtils::splitTotalInTwo($total - $random, $minValue, $maxValue, $size / 2, $stepNum+1, RandomSequenceGenerator::num(0, 100)*$balanceFactor/100)
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
