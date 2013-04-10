<?php
// src/Projects/SocialSportsBundle/Entity/Manager.php
namespace Projects\SocialSportsBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use Projects\SocialSportsBundle\Entity\People;
use JMS\Serializer\Annotation\ExclusionPolicy;
use JMS\Serializer\Annotation\Exclude;
use Doctrine\Common\Collections\ArrayCollection;

/**
 * @ORM\Entity(repositoryClass="Projects\SocialSportsBundle\Entity\ManagerRepository")
 * @ORM\Table(name="manager")
 */
class Manager
{
    //--------------------------------------------------------------------
    // VARIABLES
    //--------------------------------------------------------------------

    /**
     * @ORM\Id
     * @ORM\Column(name="facebook_id", length=45)
     * @Exclude
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
     * @ORM\Column(type="integer")
     */
    protected $coins;

    /**
     * @ORM\Column(type="smallint")
     */
    protected $unlockingProgress;

    /**
     * @ORM\OneToMany(targetEntity="ManagerToLockedPeople", mappedBy="manager")
     **/
    protected $lockedPlayers;

    /**
    * @ORM\ManyToMany(targetEntity="Player", inversedBy="managers")
    * @ORM\JoinTable(name="manager_unlocked_players",
    *  joinColumns={@ORM\JoinColumn(name="manager_id", referencedColumnName="facebook_id")},
    *  inverseJoinColumns={@ORM\JoinColumn(name="people_id", referencedColumnName="facebook_id")}
    * )
    */
    protected $unlockedPlayers;

    /**
     * @ORM\OneToMany(targetEntity="Team", mappedBy="manager", cascade={"persist", "remove"})
     **/
    protected $teams;

    //--------------------------------------------------------------------
    // CONSTRUCTOR
    //--------------------------------------------------------------------

    public function __construct()
    {
        $this->lockedPlayers = new ArrayCollection();
        $this->unlockedPlayers = new ArrayCollection();
        $this->teams = new ArrayCollection();
    }

    //--------------------------------------------------------------------
    // GETTERS AND SETTERS
    //--------------------------------------------------------------------

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
     * Set unlockingProgress
     *
     * @param integer $unlockingProgress
     * @return Manager
     */
    public function setUnlockingProgress($unlockingProgress)
    {
        $this->unlockingProgress = $unlockingProgress;

        return $this;
    }

    /**
     * Get unlockingProgress
     *
     * @return integer
     */
    public function getUnlockingProgress()
    {
        return $this->unlockingProgress;
    }

    /**
     * Set lockedPlayers
     *
     * @param ArrayCollection $lockedPlayers
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
     * @return ArrayCollection
     */
    public function getLockedPlayers()
    {
        return $this->lockedPlayers;
    }

    /**
     * Set unlockedPlayers
     *
     * @param ArrayCollection $unlockedPlayers
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
     * @return ArrayCollection
     */
    public function getUnlockedPlayers()
    {
        return $this->unlockedPlayers;
    }

    /**
     * Set teams
     *
     * @param ArrayCollection $teams
     * @return Manager
     */
    public function setTeams($teams)
    {
        $this->teams = $teams;

        return $this;
    }

    /**
     * Get teams
     *
     * @return ArrayCollection
     */
    public function getTeams()
    {
        return $this->teams;
    }

    //----------------------------------------------
    // PUBLIC METHODS
    //----------------------------------------------

    /**
     * adds a player to the unlockedPlayers list. If the player has just been created, we save some time and add it directly.
     * If he is not new, we check if he soesn't already exists in the list (shouldn't happen, but we never know).
     * If we may add him to the list, we remove the corresponding people from the lockedPlayers list if he exists in there.
     * @param Player $player the player we want to add to the unlockedPlayers list
     * @param bool $isNew  A boolean value indicating if the player has just been created, so we don't need to make all the checks
     */
    public function addUnlockedPlayer($em, $player, $isNew = false)
    {
        if (!$isNew)
        {
            if (!$this->unlockedPlayers->contains($player))
            {
                $this->breakManagerToLockedPeopleRelation($em, $player);

                $this->createManagerToPlayerRelation($em, $player);
            }
        }
        else
        {
            $this->createManagerToPlayerRelation($em, $player);
        }
    }

    /**
     * adds a player to the lockedPlayers list. If the player has just been created, we save some time and add it directly.
     * If he is not new, we check if he doesn't already exists in the list (shouldn't happen, but we never know).
     * @param Player $player the player we want to add to the lockedPlayers list
     * @param bool $isNew  A boolean value indicating if the player has just been created, so we don't need to make all the checks
     */
    public function addLockedPeople($em, $player, $isNew = false)
    {
        $newPeople = $player->getPeople();
        if (!$isNew)
        {
            if (!$this->lockedPlayers->exists(function($key, $lockedPeople) use ($newPeople) {
                        return $lockedPeople->getPeople()->getFacebookId() == $newPeople->getFacebookId();
                    }
                )
            )
            {
                $this->createManagerToLockedPeopleRelation($em, $newPeople);
            }
        }
        else
        {
            $this->createManagerToLockedPeopleRelation($em, $newPeople);
        }
    }

    /**
     * adds a team to the teams list
     * @param Player $player the player we want to add to the lockedPlayers list
     * @param bool $isNew  A boolean value indicating if the player has just been created, so we don't need to make all the checks
     */
    public function addTeam($em, $team, $isNew = false)
    {
        if (!$isNew)
        {
            if (!$this->teams->contains($team))
            {


                $this->teams[] = $team;
            }
        }
        else
        {
            $this->teams[] = $team;
        }
        $team->setManager($this);
    }

    //------------------------------------------------------
    // PRIVATE METHODS
    //------------------------------------------------------

    private function breakManagerToLockedPeopleRelation($em, $newPeople)
    {
        $l = sizeof($this->lockedPlayers);
        for($i = 0; $i < $l; $i++)
        {
            $pl = $this->lockedPlayers[$i]->getPeople();
            if ($pl->getFacebookId() == $newPeople->getFacebookId())
            {
                $pl->removeManagerRelation($this->lockedPlayers[$i]);
                $em->remove($this->lockedPlayers[$i]);
                $this->lockedPlayers->remove($i);
                break;
            }
        }
    }

    private function createManagerToLockedPeopleRelation($em, $newPeople)
    {
        $managerToLockedPeople = new ManagerToLockedPeople($this, $newPeople);
        $this->lockedPlayers[] = $managerToLockedPeople;
        $newPeople->addLinkedManager($managerToLockedPeople);
        $em->persist($managerToLockedPeople);
        $em->persist($newPeople);
        $em->persist($this);
    }

    private function createManagerToPlayerRelation($em, $newPlayer)
    {
        $this->unlockedPlayers[] = $newPlayer;
        $newPlayer->addManager($this);
        $em->persist($newPlayer);
        $em->persist($this);
    }
}
