<?php
namespace Classes;

use Framework\Config;
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;


class Mail
{
  private $mail;

  public function __construct()
  {
    $this->mail = new PHPMailer(true);
    
    $host = Config::getInstance()->getConfig("mailer_host");
    $username = Config::getInstance()->getConfig("mailer_username");
    $password = Config::getInstance()->getConfig("mailer_password");
    $port = Config::getInstance()->getConfig("mailer_port");
    $sender = Config::getInstance()->getConfig("mailer_sender");
    $senderName = Config::getInstance()->getConfig("mailer_sender_name");
    
    try {
      // Configuration du serveur SMTP
      $this->mail->isSMTP();
      $this->mail->Host = $host;
      $this->mail->SMTPAuth = true;
      $this->mail->Username = $username;
      $this->mail->Password = $password;
      $this->mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
      $this->mail->Port = $port;

      if (!empty($fromEmail)) {
        $this->mail->setFrom($sender, $senderName);
      }
    } catch (Exception $e) {
      throw new Exception("Erreur lors de la configuration de PHPMailer: " . $e->getMessage());
    }
  }

  public function sendEmail($to, $subject, $body, $isHtml = true, $attachments = [])
  {
    try {
      $this->mail->clearAddresses();
      $this->mail->addAddress($to);
      $this->mail->Subject = $subject;
      $this->mail->Body = $body;
      $this->mail->isHTML($isHtml);

      // Ajout des pièces jointes
      foreach ($attachments as $filePath) {
        $this->mail->addAttachment($filePath);
      }

      return $this->mail->send();
    } catch (Exception $e) {
      throw new Exception("Erreur lors de l'envoi de l'email: " . $e->getMessage());
    }
  }
}