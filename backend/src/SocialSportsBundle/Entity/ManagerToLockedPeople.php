<?php
// src/Projects/SocialSportsBundle/Entity/ManagerToLockedPeople.php
namespace Projects\SocialSportsBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use JMS\Serializer\Annotation\ExclusionPolicy;
use JMS\Serializer\Annotation\Exclude;
use Doctrine\Common\Collections\ArrayCollection;

/**
 * @ORM\Entity
 * @ORM\Table(name="manager_to_locked_people")
 */
class ManagerToLockedPeople
{
    /**
     * @ORM\Id
     * @ORM\Column(type="integer", name="id")
     * @ORM\GeneratedValue(strategy="AUTO")
     * @Exclude
     */
    protected $id;

    /**
     * @ORM\ManyToOne(targetEntity="Manager", inversedBy="lockedPlayers")
     * @ORM\JoinColumn(name="manager_id", referencedColumnName="facebook_id")
     * @Exclude
     **/
    protected $manager;

    /**
     * @ORM\ManyToOne(targetEntity="People", inversedBy="linkedManagers")
     * @ORM\JoinColumn(name="people_id", referencedColumnName="facebook_id")
     **/
    protected $people;

    //--------------------------------------------------------------------
    // CONSTRUCTOR
    //--------------------------------------------------------------------

    public function __construct($manager, $people)
    {
        $this->manager = $manager;
        $this->people = $people;
    }

    //--------------------------------------------------------------------
    // GETTERS AND SETTERS
    //--------------------------------------------------------------------

    /**
     * Set manager
     *
     * @param \Projects\SocialSportsBundle\Entity\Manager $manager
     * @return ManagerToLockedPeople
     */
    public function setManager(\Projects\SocialSportsBundle\Entity\Manager $manager = null)
    {
        $this->manager = $manager;

        return $this;
    }

    /**
     * Get manager
     *
     * @return \Projects\SocialSportsBundle\Entity\Manager
     */
    public function getManager()
    {
        return $this->manager;
    }

    /**
     * Set people
     *
     * @param \Projects\SocialSportsBundle\Entity\People $people
     * @return ManagerToLockedPeople
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

    //----------------------------------------------
    // PUBLIC METHODS
    //----------------------------------------------
}
