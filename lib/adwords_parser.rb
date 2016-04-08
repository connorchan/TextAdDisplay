require 'csv'
require 'open-uri'
class AdwordsParser
  
  def initialize(filename)
    #Instance variablrs for efficient storage of CSV file information
    @campaigns = []
    @campData = {}
    @adGroups = []
    @agData = {}
    @agMap = {}
    @ads = {}
    @kws = {}
    @negs = {}
    @file = open(filename)
  end
  
  #Getter methods for data in the AdwordsParser class
  def campaigns
    @campaigns
  end
  
  def campData
    @campData
  end
  
  def adGroups
    @adGroups
  end
  
  def agData
    @agData
  end
  
  def agMap
    @agMap
  end
  
  def ads
    @ads
  end
  
  def kws
    @kws
  end
  
  def negs
    @negs
  end
  
  def parseCampaigns
    self.getCampaigns()
    self.getCampaignData()
    self.getAdGroups()
    self.getAdGroupData()
    self.mapAdGroups()
    self.getAds()
    self.getKeywords()
    self.getNegatives()
  end
  
  def getCampaigns
    #Open AdWords CSV
    adwords = CSV.foreach("#{@file.path}", headers:true) do |row|
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
    adwords = CSV.foreach("#{@file.path}", headers:true) do |row|
      #Get the first data row for each campaign in the CSV
      if !(row['Campaign Type'].nil?)
        @campData[row['Campaign']] = row
      end
    end
  end
  
  def getAdGroups
    adwords = CSV.foreach("#{@file.path}", headers:true) do |row|
      adGroup = row['Ad Group']
      #If Ad Group hasn't been collected yet, add it to the array
      if (@adGroups.include? adGroup) || (adGroup.nil?)
        next
      else
        @adGroups << adGroup
      end
    end
  end
  
  def getAdGroupData
    adwords = CSV.foreach("#{@file.path}", headers:true) do |row|
      #Get the first data row for each Ad Group in the CSV
      if !(row['Ad Group Type'].nil?)
        @agData[row['Ad Group']] = row
      end
    end
  end
  
  def mapAdGroups
    adwords = CSV.foreach("#{@file.path}", headers:true) do |row|
      if (@agMap[row['Campaign']].nil?)
        @agMap[row['Campaign']] = []
      end
      #for @agMap hash: Key = Campaign, Value = Ad Group
      if !(@agMap[row['Campaign']].include? row['Ad Group']) & !(row['Ad Group'].nil?)
        @agMap[row['Campaign']] << row['Ad Group']
      end
    end
  end
  
  def getAds
    adwords = CSV.foreach("#{@file.path}", headers:true) do |row|
      ad = []
      if (@ads[row['Ad Group']].nil?)
        @ads[row['Ad Group']] = []
      end
      #Add select components of text ads to the array, then add the array to the @ads hash
      if !(row['Headline'].nil?) & !(row['Display URL'].nil?) & !(row['Description Line 1'].nil?) & !(row['Description Line 2'].nil?)
        ad << row['Headline']
        ad << row['Display URL']
        ad << row['Description Line 1']
        ad << row['Description Line 2']
        ad << row['Final URL'] || "#"
        @ads[row['Ad Group']] << ad
      end
    end
  end
  
  def getKeywords
    adwords = CSV.foreach("#{@file.path}", headers:true) do |row|
      kwData = []
      if (@kws[row['Ad Group']].nil?)
        @kws[row['Ad Group']] = []
      end
      #Add select components of keywords to the array, then add the array to the @kws hash
      if !(row['Keyword'].nil?) & !(row['Criterion Type'].nil?) & !(row['Criterion Type'].to_s.include? "Negative")
        kwData << row['Keyword']
        kwData << row['Criterion Type']
        if (row['Max CPC'].nil?)
          kwData << "0"
        else
          kwData << row['Max CPC']
        end
        @kws[row['Ad Group']] << kwData
      end
    end
  end
  
  def getNegatives
    #Find the negative keywords for each ad group and add them to a hash.
    adwords = CSV.foreach("#{@file.path}", headers:true) do |row|
      negData = []
      if (@negs[row['Ad Group']].nil?)
        @negs[row['Ad Group']] = []
      end
      if !(row['Keyword'].nil?) & !(row['Criterion Type'].nil?) & (row['Criterion Type'].to_s.include? "Negative")
        negData << row['Keyword']
        negData << row['Criterion Type']
        @negs[row['Ad Group']] << negData
      end
    end
  end
  
  def validate_file_type
    #Column headers for a standard AdWords CSV export
    adWordsHeaders = ["Campaign Type", "Ad Group", "Ad Group Type", "Description Line 1", "Description Line 2", "Final URL", "Keyword", "Criterion Type", "Max CPC"]
    #If the column headers in the user-uploaded CSV match, return a valid file type. Otherwise, false.
    fileFirstRow = CSV.open("#{@file.path}", 'r') { |csv| csv.first }  
    if (fileFirstRow & adWordsHeaders).any?
      fileType = "Google AdWords"
    end
    fileType || false
  end
  
end