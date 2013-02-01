<?php

namespace Projects\SocialSportsBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Response;

class DefaultController extends Controller
{
    public function indexAction()
    {
        $facebook = $this->get('facebook');

        return $this->render('ProjectsSocialSportsBundle:Default:template.html.twig', array('facebook' => $facebook));
    }

    public function facebookLoginAction()
    {
        $facebook = $this->get('facebook');
        if ( $facebookId = $facebook->getUser() ){
           $userProfile = $facebook->api('/me');
           $userFriends = $facebook->api('/me/friends');
           return $this->render('ProjectsSocialSportsBundle:Default:index.html.twig',
                                array(
                                    'name' => $userProfile['name'],
                                    'friends' => $userFriends
                                )
                        );
        } else {
            echo "not authenticated";
            // not authenticated.
            #return $this->redirect($facebook->getLoginUrl(array('redirect_uri' => 'social_sports_facebook_login')));
            #return $this->render('ProjectsSocialSportsBundle:Default:template.html.twig', array('facebook' => $facebook));
            $loginUrl = $facebook->getLoginUrl(array('redirect_uri' => 'https://apps.facebook.com/socialsports_dev/'));
            return new Response("<script type='text/javascript'>top.location.href = '".$loginUrl."';</script>");
        }
    }

    public function facebookLoginWithSessionAction()
    {
        $facebook = $this->get('facebook');
        $uid = $facebook->getUser();
        if ($uid) {
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
                    $userProfile = $facebook->api('/me');
                    $userFriends = $facebook->api('/me/friends');
                    // On stock les infos de l'utilisateur en session: Pseudo cache
                    $_SESSION['uid'] = $uid;
                    $_SESSION['user'] = $userProfile;
                    $_SESSION['friends'] = $userFriends;
                }
                return $this->render('ProjectsSocialSportsBundle:Default:index.html.twig',
                    array(
                        'name' => $userProfile['name'],
                        'friends' => $userFriends
                    )
                );
            } catch (FacebookApiException $e) {
                // S'il y'a un problème lors de la récup, perte de session entre temps, suppression des autorisations...
                // On récupère l'URL sur laquelle on devra rediriger l'utilisateur pour le réidentifier sur l'application
                $loginUrl = $facebook->getLoginUrl(array('redirect_uri' => 'https://apps.facebook.com/socialsports_dev/'));
                return new Response("<script type='text/javascript'>top.location.href = '".$loginUrl."';</script>");
            }
        } else {
            echo "not authenticated";
            // not authenticated.
            #return $this->redirect($facebook->getLoginUrl(array('redirect_uri' => 'social_sports_facebook_login')));
            #return $this->render('ProjectsSocialSportsBundle:Default:template.html.twig', array('facebook' => $facebook));
            $loginUrl = $facebook->getLoginUrl(array('redirect_uri' => 'https://apps.facebook.com/socialsports_dev/'));
            return new Response("<script type='text/javascript'>top.location.href = '".$loginUrl."';</script>");
        }
    }
}
