# shellcheck disable=SC2044
for i in $(find ./content/posts -type f -name "*.md");
do
    echo "Markdown file: $i"
    path="${i%/*}/"
    echo "Directory: $path"
    # shellcheck disable=SC2016
    for j in $(rg --pcre2 "\!\[[^\]]*\]\(((?!http).*?)\s*(\"(?:.*[^\"])\")?\s*\)" -or '$1' "$i");
    do
      echo "File: $j"

      if [[ $j == *"/uploads/"* ]]; then
        echo "Image is in uploads folder"
        filePath="./content$j"
      else
        filePath="$path$j"
      fi
      echo "FilePath: $filePath"

      json=$(curl -F "UPLOADCARE_PUB_KEY=d92ab83842bf39b45c62" \
           -F "UPLOADCARE_STORE=auto" \
           -F "file=@$filePath" \
           "https://upload.uploadcare.com/base/")

      id=$(echo "$json" | jq -r '.file')
      echo "UploadCare ID: $id"

      if [[ -n "$id" ]]; then
          uploadCareURL="https://ucarecdn.com/$id/$j"
          echo "UploadCare URL: $uploadCareURL"
          sed -i '' "s+$j+$uploadCareURL+g" "$i"
          rm "$filePath"
          echo "Successfully migrated $j"
      else
          echo "Error migrating $j: UploadCare ID null or empty"
      fi

    done
done
