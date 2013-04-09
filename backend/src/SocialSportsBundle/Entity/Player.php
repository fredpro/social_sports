<?php
// src/Projects/SocialSportsBundle/Entity/Player.php
namespace Projects\SocialSportsBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use Projects\SocialSportsBundle\Entity\People;
use JMS\Serializer\Annotation\ExclusionPolicy;
use JMS\Serializer\Annotation\Exclude;
use Doctrine\Common\Collections\ArrayCollection;

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
     * @Exclude
     */
    protected $facebookId;

    /**
     * @ORM\OneToOne(targetEntity="People")
     * @ORM\JoinColumn(name="people_id", referencedColumnName="facebook_id")
     **/
    protected $people;

    /**
     * @ORM\Column(type="json_array")
     */
    protected $attributes;

    /**
    * @ORM\ManyToMany(targetEntity="Manager", mappedBy="unlockedPlayers")
    * @Exclude
    */
    protected $managers;

    //--------------------------------------------------------------------
    // CONSTRUCTOR
    //--------------------------------------------------------------------

    public function __construct()
    {
        $this->managers = new ArrayCollection();
    }

    //--------------------------------------------------------------------
    // GETTERS AND SETTERS
    //--------------------------------------------------------------------

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

    /**
     * Set managers
     *
     * @param ArrayCollection $managers
     * @return Player
     */
    public function setManager(ArrayCollection $managers = null)
    {
        $this->managers = $managers;

        return $this;
    }

    /**
     * Get managers
     *
     * @return ArrayCollection
     */
    public function getManager()
    {
        return $this->managers;
    }

    //----------------------------------------------
    // PUBLIC METHODS
    //----------------------------------------------

    /**
     * adds a manager as one of the player's manager.
     * @param Manager $manager the manager which will added to the managers list
     */
    public function addManager($manager)
    {
        if (!$this->managers->contains($manager))
        {
            $this->managers[] = $manager;
        }
    }
}
