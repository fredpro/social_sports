<?php
// src/Projects/SocialSportsBundle/Entity/FootballTeam.php
namespace Projects\SocialSportsBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use Projects\SocialSportsBundle\Entity\Player;

/**
 * @ORM\Entity
 * @ORM\Table(name="football_team")
 */
class FootballTeam
{
    /**
     * @ORM\Id
     * @ORM\Column(type="integer", name="football_team_id")
     * @ORM\GeneratedValue(strategy="AUTO")
     */
    protected $footballTeamId;

    /**
     * @ORM\OneToOne(targetEntity="Manager", inversedBy="footballTeam")
     * @ORM\JoinColumn(name="manager_id", referencedColumnName="facebook_id")
     **/
    protected $manager;

    /**
     * @ORM\ManyToOne(targetEntity="Player")
     * @ORM\JoinColumn(name="player_facebook_id1", referencedColumnName="facebook_id")
     **/
    protected $playerId_1;

    /**
     * @ORM\ManyToOne(targetEntity="Player")
     * @ORM\JoinColumn(name="player_facebook_id2", referencedColumnName="facebook_id")
     **/
    protected $playerId_2;

    /**
     * @ORM\ManyToOne(targetEntity="Player")
     * @ORM\JoinColumn(name="player_facebook_id3", referencedColumnName="facebook_id")
     **/
    protected $playerId_3;

    /**
     * @ORM\ManyToOne(targetEntity="Player")
     * @ORM\JoinColumn(name="player_facebook_id4", referencedColumnName="facebook_id")
     **/
    protected $playerId_4;

    /**
     * @ORM\ManyToOne(targetEntity="Player")
     * @ORM\JoinColumn(name="player_facebook_id5", referencedColumnName="facebook_id")
     **/
    protected $playerId_5;

    /**
     * @ORM\ManyToOne(targetEntity="Player")
     * @ORM\JoinColumn(name="player_facebook_id6", referencedColumnName="facebook_id")
     **/
    protected $playerId_6;

    /**
     * @ORM\ManyToOne(targetEntity="Player")
     * @ORM\JoinColumn(name="player_facebook_id7", referencedColumnName="facebook_id")
     **/
    protected $playerId_7;

    /**
     * @ORM\ManyToOne(targetEntity="Player")
     * @ORM\JoinColumn(name="player_facebook_id8", referencedColumnName="facebook_id")
     **/
    protected $playerId_8;

    /**
     * @ORM\ManyToOne(targetEntity="Player")
     * @ORM\JoinColumn(name="player_facebook_id9", referencedColumnName="facebook_id")
     **/
    protected $playerId_9;

    /**
     * @ORM\ManyToOne(targetEntity="Player")
     * @ORM\JoinColumn(name="player_facebook_id10", referencedColumnName="facebook_id")
     **/
    protected $playerId_10;

    /**
     * @ORM\ManyToOne(targetEntity="Player")
     * @ORM\JoinColumn(name="player_facebook_id11", referencedColumnName="facebook_id")
     **/
    protected $playerId_11;

    /**
     * Get footballTeamId
     *
     * @return integer 
     */
    public function getFootballTeamId()
    {
        return $this->footballTeamId;
    }

    /**
     * Set manager
     *
     * @param \Projects\SocialSportsBundle\Entity\Manager $manager
     * @return FootballTeam
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
     * Set playerId_1
     *
     * @param \Projects\SocialSportsBundle\Entity\Player $playerId1
     * @return FootballTeam
     */
    public function setPlayerId1(\Projects\SocialSportsBundle\Entity\Player $playerId1 = null)
    {
        $this->playerId_1 = $playerId1;
    
        return $this;
    }

    /**
     * Get playerId_1
     *
     * @return \Projects\SocialSportsBundle\Entity\Player 
     */
    public function getPlayerId1()
    {
        return $this->playerId_1;
    }

    /**
     * Set playerId_2
     *
     * @param \Projects\SocialSportsBundle\Entity\Player $playerId2
     * @return FootballTeam
     */
    public function setPlayerId2(\Projects\SocialSportsBundle\Entity\Player $playerId2 = null)
    {
        $this->playerId_2 = $playerId2;
    
        return $this;
    }

    /**
     * Get playerId_2
     *
     * @return \Projects\SocialSportsBundle\Entity\Player 
     */
    public function getPlayerId2()
    {
        return $this->playerId_2;
    }

    /**
     * Set playerId_3
     *
     * @param \Projects\SocialSportsBundle\Entity\Player $playerId3
     * @return FootballTeam
     */
    public function setPlayerId3(\Projects\SocialSportsBundle\Entity\Player $playerId3 = null)
    {
        $this->playerId_3 = $playerId3;
    
        return $this;
    }

    /**
     * Get playerId_3
     *
     * @return \Projects\SocialSportsBundle\Entity\Player 
     */
    public function getPlayerId3()
    {
        return $this->playerId_3;
    }

    /**
     * Set playerId_4
     *
     * @param \Projects\SocialSportsBundle\Entity\Player $playerId4
     * @return FootballTeam
     */
    public function setPlayerId4(\Projects\SocialSportsBundle\Entity\Player $playerId4 = null)
    {
        $this->playerId_4 = $playerId4;
    
        return $this;
    }

    /**
     * Get playerId_4
     *
     * @return \Projects\SocialSportsBundle\Entity\Player 
     */
    public function getPlayerId4()
    {
        return $this->playerId_4;
    }

    /**
     * Set playerId_5
     *
     * @param \Projects\SocialSportsBundle\Entity\Player $playerId5
     * @return FootballTeam
     */
    public function setPlayerId5(\Projects\SocialSportsBundle\Entity\Player $playerId5 = null)
    {
        $this->playerId_5 = $playerId5;
    
        return $this;
    }

    /**
     * Get playerId_5
     *
     * @return \Projects\SocialSportsBundle\Entity\Player 
     */
    public function getPlayerId5()
    {
        return $this->playerId_5;
    }

    /**
     * Set playerId_6
     *
     * @param \Projects\SocialSportsBundle\Entity\Player $playerId6
     * @return FootballTeam
     */
    public function setPlayerId6(\Projects\SocialSportsBundle\Entity\Player $playerId6 = null)
    {
        $this->playerId_6 = $playerId6;
    
        return $this;
    }

    /**
     * Get playerId_6
     *
     * @return \Projects\SocialSportsBundle\Entity\Player 
     */
    public function getPlayerId6()
    {
        return $this->playerId_6;
    }

    /**
     * Set playerId_7
     *
     * @param \Projects\SocialSportsBundle\Entity\Player $playerId7
     * @return FootballTeam
     */
    public function setPlayerId7(\Projects\SocialSportsBundle\Entity\Player $playerId7 = null)
    {
        $this->playerId_7 = $playerId7;
    
        return $this;
    }

    /**
     * Get playerId_7
     *
     * @return \Projects\SocialSportsBundle\Entity\Player 
     */
    public function getPlayerId7()
    {
        return $this->playerId_7;
    }

    /**
     * Set playerId_8
     *
     * @param \Projects\SocialSportsBundle\Entity\Player $playerId8
     * @return FootballTeam
     */
    public function setPlayerId8(\Projects\SocialSportsBundle\Entity\Player $playerId8 = null)
    {
        $this->playerId_8 = $playerId8;
    
        return $this;
    }

    /**
     * Get playerId_8
     *
     * @return \Projects\SocialSportsBundle\Entity\Player 
     */
    public function getPlayerId8()
    {
        return $this->playerId_8;
    }

    /**
     * Set playerId_9
     *
     * @param \Projects\SocialSportsBundle\Entity\Player $playerId9
     * @return FootballTeam
     */
    public function setPlayerId9(\Projects\SocialSportsBundle\Entity\Player $playerId9 = null)
    {
        $this->playerId_9 = $playerId9;
    
        return $this;
    }

    /**
     * Get playerId_9
     *
     * @return \Projects\SocialSportsBundle\Entity\Player 
     */
    public function getPlayerId9()
    {
        return $this->playerId_9;
    }

    /**
     * Set playerId_10
     *
     * @param \Projects\SocialSportsBundle\Entity\Player $playerId10
     * @return FootballTeam
     */
    public function setPlayerId10(\Projects\SocialSportsBundle\Entity\Player $playerId10 = null)
    {
        $this->playerId_10 = $playerId10;
    
        return $this;
    }

    /**
     * Get playerId_10
     *
     * @return \Projects\SocialSportsBundle\Entity\Player 
     */
    public function getPlayerId10()
    {
        return $this->playerId_10;
    }

    /**
     * Set playerId_11
     *
     * @param \Projects\SocialSportsBundle\Entity\Player $playerId11
     * @return FootballTeam
     */
    public function setPlayerId11(\Projects\SocialSportsBundle\Entity\Player $playerId11 = null)
    {
        $this->playerId_11 = $playerId11;
    
        return $this;
    }

    /**
     * Get playerId_11
     *
     * @return \Projects\SocialSportsBundle\Entity\Player 
     */
    public function getPlayerId11()
    {
        return $this->playerId_11;
    }
}