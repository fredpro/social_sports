<?php
// src/Projects/SocialSportsBundle/Entity/People.php
namespace Projects\SocialSportsBundle\Entity;

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
    protected $nickname;

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

    //--------------------------------------------------------------------
    // PUBLIC METHODS
    //--------------------------------------------------------------------

    public function initializeFromFacebookUser($facebookUser)
    {
        $this->facebookId = $facebookUser['id'];
        $this->nickname = '';
    }
}