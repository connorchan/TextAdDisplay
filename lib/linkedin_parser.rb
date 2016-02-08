require 'csv'
require 'open-uri'
class LinkedinParser
  
  def initialize(filename)
    @campaigns = []
    @campData = {}
    @posts = {}
    @file = open(filename)
  end
  
  def campaigns
    @campaigns
  end
  
  def campData
    @campData
  end
  
  def posts
    @posts
  end
  
  def parsePosts
    self.getCampaigns()
    self.getCampaignData()
    self.getPosts()
  end
  
  def getCampaigns
    #Open Twitter CSV
    spons = CSV.foreach("#{@file.path}", headers:true) do |row|
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
    spons = CSV.foreach("#{@file.path}", headers:true) do |row|
      campaign = row['Campaign']
      data = []
      if !(@campData.has_key?(campaign))
        data << row['Daily Budget']
        data << row['Targeting Info']
        @campData[campaign] = data
      end
    end
  end
  
  def getPosts
    spons = CSV.foreach("#{@file.path}", headers:true) do |row|
      promtweet = []
      if (@posts[row['Campaign']].nil?)
        @posts[row['Campaign']] = []
      end
      
      if !(row['Account Name'].nil?)
        promtweet << row['Account Name']
      else
        promtweet << 0
      end
      
      if !(row['Link to Profile Picture'].nil?)
        promtweet << row['Link to Profile Picture']
      else
        promtweet << " "
      end
      
      if !(row['Image Link'].nil?)
        promtweet << row['Image Link']
      else
        promtweet << " "
      end
      
      if !(row['Introduction'].nil?)
        promtweet << row['Introduction']
      else
        promtweet << "An introduction for your post."
      end
      
      if !(row['Title'].nil?)
        promtweet << row['Title']
      else
        promtweet << "The Title of Your Post"
      end
      
      if !(row['Description'].nil?)
        promtweet << row['Description']
      else
        promtweet << "A description of your sponsored post."
      end
      
      if !(row['Display URL'].nil?)
        promtweet << row['Display URL']
      else
        promtweet << "yoursite.com"
      end
      
      if !(row['Landing Page URL'].nil?)
        promtweet << row['Landing Page URL']
      else
        promtweet << "https://bit.ly/yrlandingpage"
      end
      
      @posts[row['Campaign']] << promtweet
    end
  end
  
  def validate_file_type
    headers = [["Account Name", "Link to Profile Picture", "Campaign", "Daily Budget", "Targeting Info", "Image Link", "Introduction", "Title", "Description", "Display URL", "Landing Page URL"]]
    fileFirstRow = CSV.open("#{@file.path}", 'r') { |csv| csv.first }
    if headers.include? fileFirstRow
      fileType = "LinkedIn"
    end
    fileType || false
  end
  
end