<?php

namespace Projects\SocialSportsBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Response;
use Projects\SocialSportsBundle\Entity\Manager;

class FacebookController extends Controller
{
    public function indexAction()
    {
        $facebook = $this->get('facebook');

        return $this->render('ProjectsSocialSportsBundle:Default:template.html.twig', array('facebook' => $facebook));
    }

    public function facebookLoginWithSessionAction()
    {
        $facebook = $this->get('facebook');
        $uid = $facebook->getUser();
        if ($uid)
        {
            try
            {
                // On teste si l'utilisateur est en session
                if (isset($_SESSION['user']) && isset($_SESSION['uid']))
                {
                    // On récupère les données en session: Gain en perf: économie d'appel à l'API
                    $userProfile = $_SESSION['user'];
                    $userFriends = $_SESSION['friends'];
                    $uid = $_SESSION['uid'];
                }
                else
                {
                    // On récupère l'UID de l'utilisateur Facebook courant
                    $uid = $facebook->getUser();
                    // On récupère les infos de base de l'utilisateur
                    $userProfile = $facebook->api('/me?fields=id,birthday,name,gender,picture');
                    $userFriends = $facebook->api('me/friends?fields=id,birthday,name,gender,picture');
                    // On stock les infos de l'utilisateur en session: Pseudo cache
                    $_SESSION['uid'] = $uid;
                    $_SESSION['user'] = $userProfile;
                    $_SESSION['friends'] = $userFriends;
                }

                //#FIXME : for work purpose, I removed the limitation during the first sprints
                if (sizeof($userFriends['data']) < 1)//Manager::INITIAL_NUMBER_OF_UNLOCKED_PLAYERS)
                {
                    // the user doesn't have enough facebook friends to play the game
                    return $this->render('ProjectsSocialSportsBundle:Facebook:not_enough_friends.html.twig',
                        array(
                            'name' => $userProfile['name'],
                            'minFriends' => Manager::INITIAL_NUMBER_OF_UNLOCKED_PLAYERS
                        )
                    );
                }

                return $this->forward('ProjectsSocialSportsBundle:User:getUserProfile', array(
                    'facebookUser' => $userProfile,
                    'facebookFriends' => $userFriends
                    )
                );
            }
            catch (FacebookApiException $e)
            {
                // S'il y'a un problème lors de la récup, perte de session entre temps, suppression des autorisations...
                // On récupère l'URL sur laquelle on devra rediriger l'utilisateur pour le réidentifier sur l'application
                $params = array(
                    'redirect_uri' => 'https://apps.facebook.com/socialsports_dev/',
                    'scope' => 'user_birthday,  friends_birthday',
                );
                $loginUrl = $facebook->getLoginUrl($params);
                return new Response("<script type='text/javascript'>top.location.href = '".$loginUrl."';</script>");
            }
        }
        else
        {
            echo "not authenticated";
            // not authenticated.
            #return $this->redirect($facebook->getLoginUrl(array('redirect_uri' => 'social_sports_facebook_login')));
            #return $this->render('ProjectsSocialSportsBundle:Default:template.html.twig', array('facebook' => $facebook));
            $params = array(
                'redirect_uri' => 'https://apps.facebook.com/socialsports_dev/',
                'scope' => 'user_birthday,  friends_birthday',
            );
            $loginUrl = $facebook->getLoginUrl($params);
            return new Response("<script type='text/javascript'>top.location.href = '".$loginUrl."';</script>");
        }
    }
}
