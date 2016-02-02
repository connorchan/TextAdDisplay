require 'csv'
require 'open-uri'
class TweetsParser
  
  def initialize(filename)
    @campaigns = []
    @campData = {}
    @tweets = {}
    @filename = open(filename).path
  end
  
  def campaigns
    @campaigns
  end
  
  def campData
    @campData
  end
  
  def tweets
    @tweets
  end
  
  def parseTweets
    self.getCampaigns()
    self.getCampaignData()
    self.getTweets()
  end
  
  def getCampaigns
    #Open Twitter CSV
    twits = CSV.foreach("#{@filename}", headers:true) do |row|
      campName = row['Campaign']
      #If campaign name doesn't exist in the array, add it
      if (@campaigns.include? campName) || (campName.nil?)
        next
      else
        @campaigns << campName
      end
    end
  end
  
  def getCampaignData
    twits = CSV.foreach("#{@filename}", headers:true) do |row|
      campaign = row['Campaign']
      data = []
      if !(@campData.has_key?(campaign))
        data << row['Daily Budget']
        data << row['Targeting Options']
        @campData[campaign] = data
      end
    end
  end
  
  def getTweets
    twits = CSV.foreach("#{@filename}", headers:true) do |row|
      promtweet = []
      if (@tweets[row['Campaign']].nil?)
        @tweets[row['Campaign']] = []
      end
      
      if !(row['Image Link'].nil?)
        promtweet << row['Image Link']
      else
        promtweet << 0
      end
      
      if !(row['CTA'].nil?)
        promtweet << row['CTA']
      else
        promtweet << 0
      end
      
      if !(row['Headline'].nil?)
        promtweet << row['Headline']
      else
        promtweet << 0
      end
      
      if !(row['Display URL'].nil?)
        promtweet << row['Display URL']
      else
        promtweet << 0
      end
      
      if !(row['Tweet'].nil?)
        promtweet << row['Tweet']
      else
        promtweet << "Write a tweet to promote your brand! So few characters, so much time."
      end
      
      if !(row['Account Name'].nil?)
        promtweet << row['Account Name']
      else
        promtweet << 0
      end
      
      if !(row['Twitter Handle'].nil?)
        promtweet << row['Twitter Handle']
      else
        promtweet << 0
      end
      
      if !(row['Link to Profile Picture'].nil?)
        promtweet << row['Link to Profile Picture']
      else
        promtweet << 0
      end
      
      @tweets[row['Campaign']] << promtweet
    end
  end
  
  def validate_file_type
    headers = [["Account Name", "Twitter Handle", "Link to Profile Picture", "Campaign", "Daily Budget", "Targeting Options", "Image Link", "CTA", "Headline", "Display URL", "Tweet"]]
    fileFirstRow = CSV.open("#{@filename}", 'r') { |csv| csv.first }
    if headers.include? fileFirstRow
      fileType = "Twitter"
    end
    fileType || false
  end
  
end