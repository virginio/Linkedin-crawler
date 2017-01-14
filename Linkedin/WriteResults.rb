require 'uri'
require 'net/http'
require 'open-uri'
require 'rexml/document'
require 'date'
require 'rubygems'
require 'json'
require 'csv'
require 'axlsx'

module Writer
    def writeCSV (project,current_experience,past_experience,languages,education)


p = Axlsx::Package.new
wb = p.workbook


wb.add_worksheet(:name => "Profile") do |sheet|
    attributes = project[0].map{ |k,v| [k.to_s.capitalize]}.flatten
    sheet.add_row attributes
    #project.each { |k| puts k[:description]}
    project.each { |g|
        
        #puts a
        sheet.add_row g.values}
    end
    
    wb.add_worksheet(:name => "Current position") do |sheet|
        job_attributes = ["Name","Title","Company","Start date","End date"]
        sheet.add_row job_attributes
        
        current_experience.each_with_index { |profile,i|
        name = profile[0]
        profile.shift
        profile.length.times {|i| sheet.add_row [name,profile[i].flatten].flatten}
        }
        end
        
    wb.add_worksheet(:name => "Past experience") do |sheet|
        past_experience.each_with_index { |profile2,i|
        name2 = profile2[0]
            profile2.shift
            profile2.each {|job|
            job.length.times {|k| sheet.add_row [name2,job[k].flatten].flatten}
            
            }
            
            
        }
        end
    
    
    wb.add_worksheet(:name => "Languages") do |sheet|
        languages.each_with_index { |language,i|
            name2 = language[0]
            language.shift
            
            
            language.each {|l|
                l.length.times {|k| sheet.add_row [name2,l[k].flatten].flatten}
                
            }
            
            
        }
    end
    
    wb.add_worksheet(:name => "Education") do |sheet|
        education.each_with_index { |institution,i|
            name2 = institution[0]
            institution.shift
            
            
            institution.each {|e|
                e.length.times {|k| sheet.add_row [name2,e[k].flatten].flatten}
                
            }
            
            
        }
    end


        
   
    
    
    




p.use_shared_strings = true
file_name ='Linkedin.xlsx'
p.serialize(file_name)


end
    
end

