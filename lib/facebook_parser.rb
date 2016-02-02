require 'csv'
require 'open-uri'
class FacebookParser
  
  def initialize(filename)
    @campaigns = []
    @campData = {}
    @adSets = []
    @agMap = {}
    @ads = {}
    @filename = open(filename)
  end
  
  def campaigns
    @campaigns
  end
  
  def campData
    @campData
  end
  
  def adSets
    @adSets
  end
  
  def agMap
    @agMap
  end
  
  def ads
    @ads
  end
  
  def parseCampaigns
    self.getCampaigns()
    self.getCampaignData()
    self.getAdSets()
    self.mapAdSets()
    self.getAds()
  end
  
  def getCampaigns
    facebook = CSV.foreach("#{@filename.path}", headers:true) do |row|
      campName = row['Campaign']
      if (@campaigns.include? campName) || (campName.nil?)
        next
      else
        @campaigns << campName
      end
    end
  end
  
  def getCampaignData
    facebook = CSV.foreach("#{@filename.path}", headers:true) do |row|
      campaign = row['Campaign']
      data = []
      if !(@campData.has_key?("#{campaign}"))
        data << row['Daily Budget'] || 1
        data << row['Targeting Options'] || 1
        @campData[campaign] = data
      end
    end
  end
  
  def getAdSets
    facebook = CSV.foreach("#{@filename.path}", headers:true) do |row|
      adSet = row['Ad Group']
      if (@adSets.include? adSet) || (adSet.nil?)
        next
      else
        @adSets << adSet
      end
    end
  end
  
  def mapAdSets
    facebook = CSV.foreach("#{@filename.path}", headers:true) do |row|
      if (@agMap[row['Campaign']].nil?)
        @agMap[row['Campaign']] = []
      end
      
      if !(@agMap[row['Campaign']].include? row['Ad Set']) & !(row['Ad Set'].nil?)
        @agMap[row['Campaign']] << row['Ad Set']
      end
    end
  end
  
  def getAds
    facebook = CSV.foreach("#{@filename.path}", headers:true) do |row|
      ad = []
      if (@ads[row['Ad Set']].nil?)
        @ads[row['Ad Set']] = []
      end
      
      if !(row['Account Name'].nil?)
        ad << row ['Account Name']
      else
        ad << 0
      end
      
      if !(row['Link to Profile Picture'].nil?)
        ad << row['Link to Profile Picture']
      else
        ad << 0
      end
      
      if !(row['Image Link'].nil?)
        ad << row['Image Link']
      else
        ad << 0
      end
      
      if !(row['Headline'].nil?)
        ad << row['Headline']
      else
        ad << 0
      end
      
      if !(row['Link Description'].nil?)
        ad << row['Link Description']
      else
        ad << 0
      end
      
      if !(row['Main Text'].nil?)
        ad << row['Main Text']
      else
        ad << 0
      end
      
      if !(row['CTA'].nil?)
        ad << row['CTA']
      else
        ad << 0
      end
      
      if !(row['Display URL'].nil?)
        ad << row['Display URL']
      else
        ad << 0
      end
      
      @ads[row['Ad Set']] << ad
    end
  end
  
  def validate_file_type
    headers = [["Account Name", "Link to Profile Picture", "Campaign", "Ad Set", "Targeting Options", "Daily Budget", "Image Link", "Headline", "Link Description", "Main Text", "CTA", "Display URL"]]
    fileFirstRow = CSV.open("#{@filename.path}", 'r') { |csv| csv.first }
    if headers.include? fileFirstRow
      fileType = "Facebook"
    end
    fileType || false
  end
  
end
