<?php

class Database
{
    private $username = 'proiect';
    private $password = 'proiect';
    private $conn;

    public function connect()
    {
        $this->conn = oci_connect('proiect', 'proiect');

        return $this->conn;
    }
}

?>