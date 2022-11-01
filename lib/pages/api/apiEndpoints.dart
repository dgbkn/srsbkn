
var baseUrl = 'https://goyalinfocom.com/srsbkn_api/';


dynamic getApiUrl(part) {
 return Uri.parse(baseUrl+part);
}


// Paths are
// https://goyalinfocom.com/srsbkn_api/getgenres.php
// https://goyalinfocom.com/srsbkn_api/getartists.php
// https://goyalinfocom.com/srsbkn_api/getsongs.php
// https://goyalinfocom.com/srsbkn_api/getartistsongs.php?artist_id=3
// https://goyalinfocom.com/srsbkn_api/searchsongs.php?query=amrit
// https://goyalinfocom.com/srsbkn_api/getgenresongs.php?genre_id=5