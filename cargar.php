<?php

//print_r($_FILES);

header('Content-Type: text/plain; charset=utf-8');

try {
    
    // Undefined | Multiple Files | $_FILES Corruption Attack
    if (
        !isset($_FILES['archivo']['error']) ||
        is_array($_FILES['archivo']['error'])
    ) {
        throw new RuntimeException('Parámetros no validos.');
    }

    // Check $_FILES['archivo']['error'] value.
    switch ($_FILES['archivo']['error']) {
        case UPLOAD_ERR_OK:
            break;
        case UPLOAD_ERR_NO_FILE:
            throw new RuntimeException('Sin archivo.');
        case UPLOAD_ERR_INI_SIZE:
        case UPLOAD_ERR_FORM_SIZE:
            throw new RuntimeException('tamaño excedido.');
        default:
            throw new RuntimeException('Error no conocido.');
    }

    // Revisar tamaño
    if ($_FILES['archivo']['size'] > 1000000) {
        throw new RuntimeException('tamaño excedido.');
    }

    // DO NOT TRUST $_FILES['upfile']['mime'] VALUE !!
    // Check MIME Type 
    $finfo = new finfo(FILEINFO_MIME_TYPE);
    if (false === $ext = array_search(
        $finfo->file($_FILES['archivo']['tmp_name']),
        array(
            'jpg' => 'image/jpeg',
            'png' => 'image/png',
            'gif' => 'image/gif',
        ),
        true
    )) {
        throw new RuntimeException('Formato no valido.');
    }

    // NO USAR $_FILES['upfile']['name'] SIN VALIDACIONES !!
    if (!move_uploaded_file(
        $_FILES['archivo']['tmp_name'],
        sprintf('./uploads/%s.%s',
            sha1_file($_FILES['archivo']['tmp_name']),
            $ext
        )
    )) {
        throw new RuntimeException('Error al copiar el archivo.');
    }

    echo 'Carga correcta.';

} catch (RuntimeException $e) {

    echo $e->getMessage();

}


