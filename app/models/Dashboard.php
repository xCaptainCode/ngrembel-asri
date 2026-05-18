<?php

use Phalcon\Mvc\Model;

class Dashboard extends Model {
   public $id;
   public $slide_img_1;
   public $slide_img_2;
   public $slide_img_3;
   public $slide_img_4;
   public $slide_img_5;
   public $tagline;
   public $quote_1;
   public $stat_1_label;
   public $stat_1_value;
   public $stat_2_label;
   public $stat_2_value;
   public $stat_3_label;
   public $stat_3_value;
   public $stat_4_label;
   public $stat_4_value;
   public $sejarah_img_url;
   public $sejarah_tahun_berdiri;
   public $sejarah_title;
   public $sejarah_paragraf_1;
   public $sejarah_paragraf_2;
   public $sejarah_paragraf_3;
   public $sejarah_year_1_lable;
   public $sejarah_year_1_value;
   public $sejarah_year_2_lable;
   public $sejarah_year_2_value;
   public $sejarah_year_3_lable;
   public $sejarah_year_3_value;
   public $sejarah_year_4_lable;
   public $sejarah_year_4_value;
   public $sejarah_year_5_lable;
   public $sejarah_year_5_value;
   public $tiket_deskripsi;
   public $tiket_weekday;
   public $tiket_weekend;
   public $jam_operasional;
   public $tagline_footer;
   public $alamat;
   public $telp;
   public $email;
   public $link_google_maps;
   public $link_facebook;
   public $link_instagram;
   public $link_youtube;
   public $link_tiktok;
   public $link_whatsapp;
   public $created_at;
   public $created_by;
   public $updated_at;
   public $updated_by;

   private static $_data = null;
   
   public function initialize() {
      $this->setSource('dashboard');
   }

   public function getSource() {
      return 'dashboard';
   }

   /**
    * Helpers to get dashboard value by column statically
    * @param string $column
    * @param mixed $default
    * @return mixed
    */
   public static function getVal($column, $default = null)
   {
      if (self::$_data === null) {
         try {
            $di = \Phalcon\Di::getDefault();
            if ($di) {
               $db = $di->getShared('db');
               self::$_data = $db->fetchOne(
                  "SELECT * FROM dashboard ORDER BY updated_at DESC NULLS LAST, created_at DESC NULLS LAST LIMIT 1",
                  \Phalcon\Db::FETCH_ASSOC
               ) ?: false;
            } else {
               self::$_data = false;
            }
         } catch (\Exception $e) {
            self::$_data = false;
         }
      }

      if (self::$_data && isset(self::$_data[$column])) {
         return self::$_data[$column];
      }

      return $default;
   }

}
