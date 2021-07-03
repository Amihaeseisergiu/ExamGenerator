<?php

class Question
{
    private $con;
 
    public function __construct($db)
    {
        $this->con = $db;
    }

    public function verifyExistence($email, $hash)
    {
        $sql = 'SELECT * FROM users WHERE email = :email AND hash = :hash';
        $stmt = oci_parse($this->con, $sql);
        oci_bind_by_name($stmt, ':email', $email, 100);
        oci_bind_by_name($stmt, ':hash', $hash);
        oci_execute($stmt);

        oci_fetch_all($stmt, $rows, OCI_ASSOC);
        $nr = count($rows);
        if($nr > 0)
            return true;
        return false;
    }

    public function callUrmatoareaIntrebare($email, $response = null)
    {
        $json = null;
        $sql = 'BEGIN execute_urmatoarea_intrebare(:json, :email, :response); END;';
        $stmt = oci_parse($this->con, $sql);
        oci_bind_by_name($stmt, ':json', $json, 4000);
        oci_bind_by_name($stmt, ':email', $email, 100);
        oci_bind_by_name($stmt, ':response', $response, 100);
        oci_execute($stmt);

        return json_decode($json);
    }
}
