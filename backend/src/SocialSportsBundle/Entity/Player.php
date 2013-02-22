<?php
// src/Projects/SocialSportsBundle/Entity/Player.php
namespace Projects\SocialSportsBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use Projects\SocialSportsBundle\Entity\People;

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
}
