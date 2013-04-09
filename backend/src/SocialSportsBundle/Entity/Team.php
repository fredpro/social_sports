<?php
// src/Projects/SocialSportsBundle/Entity/Team.php
namespace Projects\SocialSportsBundle\Entity;
use JMS\Serializer\Annotation\ExclusionPolicy;
use JMS\Serializer\Annotation\Exclude;

use Doctrine\ORM\Mapping as ORM;

/**
 * @ORM\Entity(repositoryClass="Projects\SocialSportsBundle\Entity\TeamRepository")
 * @ORM\Table(name="team")
 */
class Team
{
    const FOOTBALL_ID = 0;
    /**
     * @Exclude
     */
    public static $team_size_list = array(11);

    /**
     * @ORM\Column(type="smallint")
     */
    protected $sportId;

    /**
     * @ORM\Id
     * @ORM\Column(type="integer", name="team_id")
     * @ORM\GeneratedValue(strategy="AUTO")
     * @Exclude
     */
    protected $teamId;

    /**
     * @ORM\ManyToOne(targetEntity="Manager", inversedBy="teams")
     * @ORM\JoinColumn(name="manager_id", referencedColumnName="facebook_id")
     * @Exclude
     **/
    protected $manager;

    /**
     * @ORM\Column(type="json_array", name="players")
     */
    protected $players;

    //--------------------------------------------------------------------
    // GETTERS AND SETTERS
    //--------------------------------------------------------------------

    /**
     * Set sportId
     *
     * @param integer $sportId
     * @return Manager
     */
    public function setSportId($sportId)
    {
        $this->sportId = $sportId;

        return $this;
    }

    /**
     * Get sportId
     *
     * @return integer
     */
    public function getSportId()
    {
        return $this->sportId;
    }

    /**
     * Get teamId
     *
     * @return integer
     */
    public function getTeamId()
    {
        return $this->teamId;
    }

    /**
     * Set manager
     *
     * @param \Projects\SocialSportsBundle\Entity\Manager $manager
     * @return Team
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
     * Set players
     *
     * @param array $players
     * @return Manager
     */
    public function setPlayers($players)
    {
        $this->players = $players;

        return $this;
    }

    /**
     * Get players
     *
     * @return array
     */
    public function getPlayers()
    {
        return $this->players;
    }
}