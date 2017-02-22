#/bin/bash
MUSIC=/blackie/music/
PLAYLISTS=/blackie/music/playlists/recent
EXCL="playlists|Word|Patrol"
I=20

# Trash the previous recent playlists ...
rm -fr $PLAYLISTS/*m3u

# Find the 20 most recent ...
find $MUSIC -mindepth 2 -maxdepth 2 -type d -print0 | xargs -0 stat -c '%Y %N' | sort -n|grep -E -v ${EXCL} |tail -20 | cut -c13- | sed -e "s/'//g"| while read RECENT
do
    ALBUM=$(echo ${RECENT}|cut -c16- | sed -e 's/ /_/g' | sed -e 's/\// /g')
    COUNT=$(printf "%02d" $I)
    M3U="${PLAYLISTS}/${COUNT} $ALBUM.m3u"
#echo $M3U
    find "$RECENT" -type f > "$M3U"
    let "I -= 1"
done
