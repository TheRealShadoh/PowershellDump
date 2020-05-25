FUNCTION encode-base64 {
    $base64string = [Convert]::ToBase64String([IO.File]::ReadAllBytes($script:filename))
}
function decode-base64 {

}