module TiktokScraper
  class Video
    def initialize(video_obj)
      @obj = video_obj
    end

    def id
      item.id
    end

    def created_at
      item.createTime
    end

    def text
      item.desc
    end

    def item
      @obj
    end

    def video
      item.video
    end

    def author
      item.author
    end

    def music
      item.music
    end

    def url
      "https://tiktok.com/@#{author.uniqueId}/video/#{item.id}"
    end

    def stats
      item.authorStats
    end

    def tags
      item.textExtra
    end

    def to_hash
      {
        id: item.id,
        text: item.desc,
        createTime: item.createTime,
        authorMeta:{
            id: author.id,
            name: author.uniqueId,
            full_name: author.nickname,
            following: stats.followingCount,
            fans: stats.followerCount,
            likes: stats.heart,
            liked: stats.heartCount,
            video: stats.videoCount,
            digg: stats.diggCount,
            verified: author.verified,
            private: author.secret,
            signature: author.signature,
            avatar: author.avatarThumb,
        },
        musicMeta:{
            musicId: music.id,
            musicName: music.title,
            musicAuthor: music.authorName,
            musicOriginal: music.original,
            playUrl: music.playUrl,
        },
        covers:{
            default: video.cover,
            origin: video.originCover,
            dynamic: video.dynamicCover
        },
        imageUrl: video.shareCover.last,
        videoUrl: video.downloadAddr,
        videoMeta: { 
          width: video.width, 
          height: video.height, 
          ratio: video.ratio, 
          duration: video.duration },
        diggCount: item.diggCount,
        shareCount: item.shareCount,
        playCount: item.playCount,
        commentCount: item.commentCount,
        mentions: tags.select {|mention| mention["type"] == 0}.map {|mention| "@#{mention["userUniqueId"]}" },
        hashtags: tags.select {|mention| mention["type"] == 1}.map {|mention| {id: mention["hashtagId"], name: mention["hashtagName"]} }
      }
    end
  end
end