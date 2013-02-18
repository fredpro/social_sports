<?php
// src/Projects/SocialSportsBundle/Entity/Manager.php
namespace Projects\SocialSportsBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use Projects\SocialSportsBundle\Entity\People;

/**
 * @ORM\Entity
 * @ORM\Table(name="manager")
 */
class Manager
{
    /**
     * @ORM\Id
     * @ORM\Column(name="facebook_id", length=45)
     */
    protected $facebookId;

    /**
     * @ORM\OneToOne(targetEntity="People")
     * @ORM\JoinColumn(name="facebook_id", referencedColumnName="facebook_id")
     **/
    protected $people;

    /**
     * @ORM\Column(type="integer")
     */
    protected $xp;

    /**
     * @ORM\Column(type="smallint")
     */
    protected $level;

    /**
     * @ORM\Column(type="integer")
     */
    protected $coins;

    /**
     * @ORM\Column(type="json_array", name="locked_players")
     */
    protected $lockedPlayers;

    /**
     * @ORM\Column(type="json_array", name="unlocked_players")
     */
    protected $unlockedPlayers;

    /**
     * @ORM\OneToOne(targetEntity="FootballTeam", mappedBy="manager")
     **/
    protected $footballTeam;

    /**
     * Set facebookId
     *
     * @param string $facebookId
     * @return Manager
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

    /**
     * Set xp
     *
     * @param integer $xp
     * @return Manager
     */
    public function setXp($xp)
    {
        $this->xp = $xp;

        return $this;
    }

    /**
     * Get xp
     *
     * @return integer
     */
    public function getXp()
    {
        return $this->xp;
    }

    /**
     * Set level
     *
     * @param integer $level
     * @return Manager
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
     * Set coins
     *
     * @param integer $coins
     * @return Manager
     */
    public function setCoins($coins)
    {
        $this->coins = $coins;

        return $this;
    }

    /**
     * Get coins
     *
     * @return integer
     */
    public function getCoins()
    {
        return $this->coins;
    }

    /**
     * Set lockedPlayers
     *
     * @param array $lockedPlayers
     * @return Manager
     */
    public function setLockedPlayers($lockedPlayers)
    {
        $this->lockedPlayers = $lockedPlayers;

        return $this;
    }

    /**
     * Get lockedPlayers
     *
     * @return array
     */
    public function getLockedPlayers()
    {
        return $this->lockedPlayers;
    }

    /**
     * Set unlockedPlayers
     *
     * @param array $unlockedPlayers
     * @return Manager
     */
    public function setUnlockedPlayers($unlockedPlayers)
    {
        $this->unlockedPlayers = $unlockedPlayers;

        return $this;
    }

    /**
     * Get unlockedPlayers
     *
     * @return array
     */
    public function getUnlockedPlayers()
    {
        return $this->unlockedPlayers;
    }

    /**
     * Set people
     *
     * @param \Projects\SocialSportsBundle\Entity\People $people
     * @return Manager
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
     * Set footballTeam
     *
     * @param \Projects\SocialSportsBundle\Entity\FootballTeam $footballTeam
     * @return Manager
     */
    public function setFootballTeam(\Projects\SocialSportsBundle\Entity\FootballTeam $footballTeam = null)
    {
        $this->footballTeam = $footballTeam;

        return $this;
    }

    /**
     * Get footballTeam
     *
     * @return \Projects\SocialSportsBundle\Entity\FootballTeam
     */
    public function getFootballTeam()
    {
        return $this->footballTeam;
    }
}