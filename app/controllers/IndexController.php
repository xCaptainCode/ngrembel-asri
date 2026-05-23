<?php

use Phalcon\Mvc\Controller;

class IndexController extends Controller {
   public function indexAction() {
      $settingsRows = $this->db->fetchAll(
         "SELECT name, value FROM settings ORDER BY id ASC",
         \Phalcon\Db::FETCH_ASSOC
      );

      $settingsMap = [];
      foreach ($settingsRows as $row) {
         $rawName = isset($row['name']) ? (string) $row['name'] : '';
         $value = isset($row['value']) ? (string) $row['value'] : '';

         if ($rawName === '') {
            continue;
         }

         $normalizedName = strtolower(trim($rawName));
         $settingsMap[$normalizedName] = $value;
      }

      $dashboard = [
         'slide_img_1' => $settingsMap['slide image 1'] ?? '',
         'slide_img_2' => $settingsMap['slide image 2'] ?? '',
         'slide_img_3' => $settingsMap['slide image 3'] ?? '',
         'slide_img_4' => $settingsMap['slide image 4'] ?? '',
         'slide_img_5' => $settingsMap['slide image 5'] ?? '',
         'tagline' => $settingsMap['tagline 1'] ?? '',
         'quote_1' => $settingsMap['quote 1'] ?? '',
         'stat_1_label' => $settingsMap['stat 1 label'] ?? '',
         'stat_1_value' => $settingsMap['stat 1 value'] ?? '',
         'stat_2_label' => $settingsMap['stat 2 label'] ?? '',
         'stat_2_value' => $settingsMap['stat 2 value'] ?? '',
         'stat_3_label' => $settingsMap['stat 3 label'] ?? '',
         'stat_3_value' => $settingsMap['stat 3 value'] ?? '',
         'stat_4_label' => $settingsMap['stat 4 label'] ?? '',
         'stat_4_value' => $settingsMap['stat 4 value'] ?? '',
         'sejarah_img_url' => $settingsMap['sejarah image'] ?? '',
         'sejarah_tahun_berdiri' => $settingsMap['sejarah tahun berdiri'] ?? '',
         'sejarah_title' => $settingsMap['sejarah title'] ?? '',
         'sejarah_paragraf_1' => $settingsMap['sejarah paragraf 1'] ?? '',
         'sejarah_paragraf_2' => $settingsMap['sejarah paragraf 2'] ?? '',
         'sejarah_paragraf_3' => $settingsMap['sejarah paragraf 3'] ?? '',
         'sejarah_year_1_lable' => $settingsMap['sejarah year 1 label'] ?? '',
         'sejarah_year_1_value' => $settingsMap['sejarah year 1 value'] ?? '',
         'sejarah_year_2_lable' => $settingsMap['sejarah year 2 label'] ?? '',
         'sejarah_year_2_value' => $settingsMap['sejarah year 2 value'] ?? '',
         'sejarah_year_3_lable' => $settingsMap['sejarah year 3 label'] ?? '',
         'sejarah_year_3_value' => $settingsMap['sejarah year 3 value'] ?? '',
         'sejarah_year_4_lable' => $settingsMap['sejarah year 4 label'] ?? '',
         'sejarah_year_4_value' => $settingsMap['sejarah year 4 value'] ?? '',
         'sejarah_year_5_lable' => $settingsMap['sejarah year 5 label'] ?? '',
         'sejarah_year_5_value' => $settingsMap['sejarah year 5 value'] ?? '',
         'tiket_deskripsi' => $settingsMap['tiket deskripsi'] ?? '',
         'tiket_weekday' => $settingsMap['tiket weekday'] ?? '',
         'tiket_weekend' => $settingsMap['tiket weekend'] ?? '',
         'jam_operasional' => $settingsMap['jam operasional'] ?? '',
         'tagline_footer' => $settingsMap['tagline footer'] ?? '',
         'alamat' => $settingsMap['alamat'] ?? '',
         'telp' => $settingsMap['telp'] ?? '',
         'email' => $settingsMap['email'] ?? '',
         'link_google_maps' => $settingsMap['link google maps'] ?? '',
         'link_facebook' => $settingsMap['link facebook'] ?? '',
         'link_instagram' => $settingsMap['link instagram'] ?? '',
         'link_youtube' => $settingsMap['link youtube'] ?? '',
         'link_tiktok' => $settingsMap['link tiktok'] ?? '',
         'link_whatsapp' => $settingsMap['link whatsapp'] ?? '',
      ];

      $this->view->setVar('dashboard', $dashboard);
   }
}
