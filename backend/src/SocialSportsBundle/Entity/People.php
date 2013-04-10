<?php
// src/Projects/SocialSportsBundle/Entity/People.php
namespace Projects\SocialSportsBundle\Entity;
use JMS\Serializer\Annotation\ExclusionPolicy;
use JMS\Serializer\Annotation\Exclude;
use Doctrine\Common\Collections\ArrayCollection;

use Doctrine\ORM\Mapping as ORM;

/**
 * @ORM\Entity(repositoryClass="Projects\SocialSportsBundle\Entity\PeopleRepository")
 * @ORM\Table(name="people")
 */
class People
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
     * @ORM\Column(length=45)
     */
    protected $name;

    /**
     * @ORM\Column(length=45)
     */
    protected $nickname;

    /**
     * @ORM\Column(name="picture_url", length=256)
     */
    protected $pictureUrl;

    /**
     * @ORM\Column(type="smallint")
     */
    protected $level;

    /**
     * @ORM\OneToMany(targetEntity="ManagerToLockedPeople", mappedBy="people")
     * @Exclude
     **/
    protected $linkedManagers;

    //--------------------------------------------------------------------
    // CONSTRUCTOR
    //--------------------------------------------------------------------

    public function __construct()
    {
        $this->linkedManagers = new ArrayCollection();
    }

    //--------------------------------------------------------------------
    // GETTERS AND SETTERS
    //--------------------------------------------------------------------

    /**
     * Set facebookId
     *
     * @param string $facebookId
     * @return People
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
     * Set name
     *
     * @param string $name
     * @return People
     */
    public function setName($name)
    {
        $this->name = $name;

        return $this;
    }

    /**
     * Get name
     *
     * @return string
     */
    public function getName()
    {
        return $this->name;
    }

    /**
     * Set nickname
     *
     * @param string $nickname
     * @return People
     */
    public function setNickname($nickname)
    {
        $this->nickname = $nickname;

        return $this;
    }

    /**
     * Get nickname
     *
     * @return string
     */
    public function getNickname()
    {
        return $this->nickname;
    }

    /**
     * Set pictureUrl
     *
     * @param string $pictureUrl
     * @return People
     */
    public function setPictureUrl($pictureUrl)
    {
        $this->pictureUrl = $pictureUrl;

        return $this;
    }

    /**
     * Get pictureUrl
     *
     * @return string
     */
    public function getPictureUrl()
    {
        return $this->pictureUrl;
    }

    /**
     * Set level
     *
     * @param integer $level
     * @return People
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
     * Set linkedManagers
     *
     * @param ArrayCollection $linkedManagers
     * @return People
     */
    public function setLinkedManagers(ArrayCollection $linkedManagers = null)
    {
        $this->linkedManagers = $linkedManagers;

        return $this;
    }

    /**
     * Get linkedManagers
     *
     * @return ArrayCollection
     */
    public function getLinkedManagers()
    {
        return $this->linkedManagers;
    }

    //----------------------------------------------
    // PUBLIC METHODS
    //----------------------------------------------

    /**
     * adds a manager as one of the people's manager.
     * @param ManagerToLockedPeople $relation the relation entity between the current people and a manager
     */
    public function addLinkedManager($relation)
    {
        if ($relation != null)
        {
            $this->linkedManager[] = $relation;
        }
    }

    /**
     * Removes a relation between a manager and a people through the manager's lockedPeople list
     * @param  ManagerToLockedPeople $relation the relation between a manager and a people
     */
    public function removeManagerRelation($relation)
    {
        $this->linkedManagers->removeElement($relation);
    }
}
