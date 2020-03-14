set -e

wget -O index.gz https://commoncrawl.s3.amazonaws.com/crawl-data/CC-MAIN-2020-10/cc-index.paths.gz
gunzip index.gz

# cc-index/collections/CC-MAIN-2020-10/indexes/cdx-00258.gz

while read -r line; do
  [[ ! "$line" =~ "cdx" ]] && continue
  gz=${line##*/}
  name=${gz/.gz/}
  echo $line $name
  wget -O "$gz" "https://commoncrawl.s3.amazonaws.com/$line"
  gunzip "$gz"
  cat "$name" | cut -f1 -d')' | uniq >> domain-list
  rm "./$name"
done < index

cat domain-list | uniq > domains
rm ./domain-list

rm ./index
