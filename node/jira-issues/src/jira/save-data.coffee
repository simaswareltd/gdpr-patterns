Jira_Api        = require './api'
Data            = require '../data'
Mappings_Create = require '../../../jira-mappings/src/create'

class Save_Data
  constructor: ->
    @.jira            = new Jira_Api()
    @.data            = new Data()
    @.mappings_Create = new Mappings_Create()

  get_Issue: (key, callback)=>
    raw_Data = @.data.issue_Raw_Data(key)
    if raw_Data
      callback raw_Data
    else
      console.log("Issue #{key} didn't exist locally, so fetching it from JIRA Server")
      @.save_Issue key,(file)=>
        if not file
          callback { issue: "not found"}
        else
          if file is "404 - {\"errorMessages\":[\"Issue Does Not Exist\"],\"errors\":{}}"
            callback jira_error : 'Issue Does Not Exist'
          else

            @.data.issue_Files_Reset_cache()
            @.mappings_Create.map_Files()
            raw_Data = file.load_Json()         # to handle the issues that have been renamed
            if raw_Data
              console.log "Got data with ID: #{raw_Data?.key}"
              callback raw_Data
            else
              callback error : 'no data found'
#          raw_Data =  @.data.issue_Raw_Data(key)
#          if raw_Data
#            console.log "got raw_Data for id  #{raw_Data.key }"
#            callback raw_Data
#          else
#            console.log "raw_data was null"
#            callback error : "raw_data was null"


  save_Issue: (key, callback)=>
    @.jira.issue key, (result)=>
      if result?.jira_error
        callback result.jira_error
      else
        callback @.save_Issue_Data result

  save_Issue_Data: (data)->

    if data.key
      issue_Project = data.fields.project.name
      issue_Type = data.fields.issuetype.name
      issue_Id   = data.key
      issue =
        key: issue_Id                         # add this field to the issue data saved

      for field in data.fields._keys().sort() # only add fields that have value
        if data.fields[field]
          issue[field] = data.fields[field]

      folder = @.data.folder_Issues_Raw.path_Combine("#{issue_Project}/#{issue_Type}").folder_Create()
      file   = folder.path_Combine "/#{issue_Id}.json"
      issue.save_Json file
      return file
    else
      return null

  save_Issues: (jql, callback)=>
    #console.log 'Save issues jql: ' + jql
    @.jira.issues jql,["*all"], (data)=>
      files = []
      #console.log 'Got all files, now saving them'
      for item in data
        files.add @.save_Issue_Data(item)
      #console.log 'All files saved'
      callback files

  save_Issues_In_Project_Last_N_Hours: (project, hours, callback) =>
    @.save_Issues "project=#{project} AND updated >= -#{hours}h", callback

  save_Issues_In_Project_Last_N_Days: (project, days, callback) =>
    @.save_Issues "project=#{project} AND updated >= -#{days}d", callback

  save_Issues_In_Project_All: (project, callback) =>
    @.save_Issues "project=#{project}", callback

  save_Issues_Schema: (callback)=>
    @.jira._call_Jira 'listFields', [] ,(data)=>
      target_File = @.data.file_Fields_Schema
      data.save_Json target_File
      callback? target_File
      return target_File


module.exports = Save_Data