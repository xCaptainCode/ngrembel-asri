<?php

use Phalcon\Mvc\Controller;

class PromoController extends Controller
{
    public function indexAction()
    {
        $promotionsList = $this->db->fetchAll(
            "SELECT * FROM promotions 
             WHERE is_active = TRUE 
             AND end_date >= NOW()
             ORDER BY start_date ASC",
            \Phalcon\Db::FETCH_ASSOC
        );

        $this->view->setVar('promotionsList', $promotionsList ?: []);
    }
}
