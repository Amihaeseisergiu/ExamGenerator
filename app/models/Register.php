<?php

class Register
{
    private $con;

    public function __construct($db)
    {
        $this->con = $db;
    }

    public function insert($email, $hash)
    {
        $sql = 'SELECT * FROM users WHERE email = :email AND hash = :hash';
        $stmt = oci_parse($this->con, $sql);
        oci_bind_by_name($stmt, ':email', $email, 100);
        oci_bind_by_name($stmt, ':hash', $hash);
        oci_execute($stmt);

        oci_fetch_all($stmt, $rows, OCI_ASSOC);
        $nr = count($rows);
        if ($nr == 0)
        {
            $sql = 'INSERT INTO users VALUES (:email, :hash)';
            $stmt = oci_parse($this->con, $sql);
            oci_bind_by_name($stmt, ':email', $email, 100);
            oci_bind_by_name($stmt, ':hash', $hash);
            oci_execute($stmt);
        }
    }
}
