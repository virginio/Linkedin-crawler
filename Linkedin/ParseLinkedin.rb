require 'uri'
require 'net/http'
require 'open-uri'
require 'rexml/document'
require 'date'
require 'rubygems'
require 'nokogiri'
require 'date'
require 'json'
require 'csv'
require 'linkedin-scraper'
require 'fileutils'

require '/Users/virginio/Desktop/Coding/Data crawling/Crawling/Linkedin/WriteResults.rb'
include Writer



class Linkedin_agent
    def inspectLinkedin
        
        self.convertLinks(self.inputTest)
        self.writeCSV(@profiles_array,@current_experience, @past_experience, @languages,@education)
        
    end
    def convertLinks(links_array)
        
        @profiles_array = []
        @current_experience = [[]]
        @past_experience = [[]]
        @languages = [[]]
        @education = [[]]
        
        links_array.each do |link|
            source = Nokogiri::HTML(open(link))
            results_array = source.css("div#body div.wrapper div#main.grid-e div#content ol#result-set.photos li.vcard h2 strong a")
            results_array.each do |a|
                link = a['href']
                profile = Linkedin::Profile.get_profile(link)
                profile_hash,current_experience_array,past_experience_array,languages_array,education_array = convertHash(profile)
                @profiles_array << profile_hash
                @current_experience << current_experience_array
                @past_experience << past_experience_array
                @languages << languages_array
                @education << education_array
                
            end
        end
        
        
    end
    
    def inputTest
        #we use this as standard input method for development
        links_array = Array.new
        name = "Marco"
        surname = "Rossi"
        link = "http://www.linkedin.com/pub/dir/" + name + "/" + surname
        links_array << link
        return links_array
        
    end
    
    
    def inputFromKeyboard
        #optional
    end
    
    def inputWithLinks
        #direct links to profile from Excel sheet
    end
    
    def inputWithNameList
        #optional - names supplied from Excel sheet
    end
    
    def convertHash (linkedinProfile)
        
        convertedHash = Hash.new
        current_experience = [[]]
        past_experience = [[]]
        current_companies = [[]]
        past_companies = [[]]
        all_languages = [[]]
        language_data = [[]]
        education_data = [[]]
        all_education = [[]]
        
        
        convertedHash = {
            
            :first_name => linkedinProfile.first_name,          # The first name of the contact
            
            :last_name => linkedinProfile.last_name,           # The last name of the contact
            
            :name => linkedinProfile.name,               # The full name of the profile
            
            :jobtitle => linkedinProfile.title,               # The job title
            
            :summary => linkedinProfile.summary,             # The summary of the profile
            
            :location => linkedinProfile.location,            # The location of the contact
            
            :country => linkedinProfile.country,             # The country of the contact
            
            :industry => linkedinProfile.industry,            # The domain for which the contact belongs
            
            :picture_link => linkedinProfile.picture,             # The profile picture link of profile
            
            :skills => linkedinProfile.skills,              # Array of skills of the profile
            
            :organizations => linkedinProfile.organizations,       # Array organizations of the profile
            
            :websites => linkedinProfile.websites,            # Array of websites
            
            :groups => linkedinProfile.groups,              # Array of groups
            
            :certifications => linkedinProfile.certifications      # Array of certifications
        }
        

        
        linkedinProfile.current_companies.each {|company|  current_companies << company.values}
        linkedinProfile.past_companies.each    {|company|  past_companies << company.values}
        linkedinProfile.languages.each       {|language|  language_data << language.values}
        linkedinProfile.education.each       {|institution|  education_data << institution.values}
        
        
        
        current_experience = [convertedHash[:name], current_companies]
        past_experience = [convertedHash[:name], past_companies]
        all_languages   = [convertedHash[:name], language_data]
        all_education   = [convertedHash[:name], education_data]
        
        
        
        return convertedHash,current_experience, past_experience, all_languages, all_education
    end
    
end


agent = Linkedin_agent.new
agent.inspectLinkedin