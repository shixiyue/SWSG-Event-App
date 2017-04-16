//
//  Config.swift
//  SWSG
//
//  Created by shixiyue on 13/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

struct Config {
    
    static let noTeam = ""
    static let defaultCountry = "Singapore"
    static let joinTeam = "Request to Join"
    static let quitTeam = "Quit Team"
    static let fullTeam = "Team is Full"
    static let appURL = "gs://swsg-74fdd.appspot.com"
    
    // Keys for encode/decode:
    static let uid = "uid"
    static let user = "user"
    static let userType = "userType"
    static let profile = "profile"
    static let email = "email"
    static let password = "password"
    static let favourites = "favourites"
    static let team = "team"
    static let name = "name"
    static let username = "username"
    static let image = "image"
    static let job = "job"
    static let company = "company"
    static let country = "country"
    static let education = "education"
    static let skills = "skills"
    static let desc = "desc"
    static let isParticipant = "isParticipant"
    static let isSpeaker = "isSpeaker"
    static let isMentor = "isMentor"
    static let isOrganizer = "isOrganizer"
    static let isAdmin = "isAdmin"
    static let comment = "comment"
    static let comments = "comments"
    static let words = "words"
    static let dateTime = "date_time"
    static let details = "details"
    static let venue = "venue"
    static let id = "id"
    static let description = "description"
    static let videoLink = "videoLink"
    static let mainImage = "mainImage"
    static let images = "images"
    static let votes = "votes"
    static let mentor = "mentor"
    static let field = "field"
    static let consultationDays = "consultationDays"
    static let consultationSlots = "consultationSlots"
    static let consultationStatus = "consultationStatus"

    static let start = "start"
    static let end = "end"
    static let date = "date"

    static let mentorLabel = "Mentor"
    static let speakerLabel = "Speaker"
    static let organizerLabel = "Organizer"
    static let adminLabel = "Admin"
    
    static let speakers = "Speakers"
    static let organizers = "Organizing Team"
    static let judges = "Judges"
    static let title = "title"
    static let intro = "intro"
    static let photo = "photo"
    static let question = "question"
    static let answer = "answer"
    static let link = "link"
    
    // Parameters for UI:
    static let defaultButtonFont = UIFont(name: "Futura", size: 15)
    static let buttonCornerRadius: CGFloat = 5
    static let themeColor = UIColor(red: 232.0/255.0, green: 43.0/255.0, blue: 49.0/255.0, alpha: CGFloat(1))
    static let placeholderColor = UIColor(red: 199/255, green: 199/255, blue: 205/255, alpha: 1.0)
    static let greenColor = UIColor(red: 0/255, green: 173/255, blue: 54/255, alpha: 1.0)
    static let disableAlpha: CGFloat = 0.5
    static let enableAlpha: CGFloat = 1
    static let maximumZoomScale: CGFloat = 10
    static let minimumProfileTextFieldHeight: CGFloat = 125
    static let maxTeamMember: Int = 4
    static let upvoteDefault = UIImage(named: "upvote")
    static let upvoteFilled = UIImage(named: "upvote-filled")
    static let downvoteDefault = UIImage(named: "downvote")
    static let downvoteFilled = UIImage(named: "downvote-filled")
    static let placeholderImg = UIImage(named: "Placeholder")!
    static let defaultIdeaImage = UIImage(named: "default-idea-image")!
    static let loadingImage = UIImage(named: "loading")!
    static let defaultPersonImage = UIImage(named: "Profile")!
    static let emptyStar = UIImage(named: "Star-Empty")!
    static let fullStar = UIImage(named: "Star-Full")!
    static let defaultSponsorImage = UIImage(named: "default-sponsor-image")!
    static let chatIconWidth: CGFloat = 40
    static let headerBuffer: CGFloat = 45
    static let scrollViewOffset: CGFloat = 300
    static let keyboardOffsetSignUp: CGFloat = 94
    static let grayBorderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
    static let borderWidth: CGFloat = 1.0
    static let cornerRadius: CGFloat = 5.0
    
    // Parameters for Storyboard:
    static let launchScreen = "LaunchScreen"
    static let navigationController = "NavigationController"
    static let logInSignUp = "LoginSignup"
    static let initialScreen = "InitialScreen"
    static let menuStoryboard = "Menu"
    static let menuViewController = "MenuViewController"
    static let mainStoryboard = "Main"
    static let homeViewController = "HomeViewController"
    static let informationStoryboard = "Information"
    static let informationViewController = "InformationViewController"
    static let mentorStoryboard = "Mentor"
    static let mentorViewController = "MentorViewController"
    static let mentorAdminViewController = "MentorAdminViewController"
    static let eventStoryboard = "EventSystem"
    static let eventViewController = "EventCalendarViewController"
    static let teamStoryboard = "TeamRegistration"
    static let teamRegistrationViewController = "TeamRegistrationTableViewController"
    static let chatStoryboard = "Chat"
    static let chatViewController = "ChatViewController"
    static let ideasStoryboard = "Ideas"
    static let ideasViewController = "ideaslist"
    static let profileStoryboard = "Profile"
    static let profileViewController = "ProfileViewController"
    static let profileListViewController = "ProfileListViewController"
    static let editProfileTable = "EditProfileTable"
    static let imageCropper = "ImageCropper"
    static let imageCropperViewController = "ImageCropperViewController"
    static let uiSupporting = "UISupporting"
    static let eventPageCellView = "eventPageCellView"
    static let emptyEventView = "emptyEventView"
    static let emptyChatView = "emptyChatView"
    static let eventDetailsTableViewController = "EventDetailsTableViewController"
    static let channelPageCellView = "channelPageCellView"
    static let channelViewController = "ChannelViewController"
    static let registrationStoryboard = "Registration"
    static let registrationListViewController = "RegistrationListViewController"
    static let participantRegistrationViewController = "ParticipantRegistrationViewController"
    static let teamInfoTableViewController = "TeamInfoTableViewController"
    static let photoContentViewController = "PhotoContentViewController"
    
    //Parameters for Segues:
    static let channelListToChannel = "showChannel"
    static let channelListToCreateChannel = "showCreateChannel"
    static let mentorGridToMentor = "chosenMentor"
    static let mentorToRelatedMentor = "showRelatedMentor"
    static let channelToChannelInfo = "showChatInfo"
    static let signUpTable = "signUpTable"
    static let initialToSignUp = "showSignUp"
    static let initialToLogin = "showLogin"
    static let loginToLogin = "showLogin"
    static let signUpToLogin = "showLogin"
    static let mentorToChat = "mentorToChat"
    static let loginToSignup = "loginToSignUp"
    static let showEventDetails = "showEventDetails"
    static let profileListToProfile = "profileListToProfile"
    static let profileToEditProfile = "profileToEditProfile"
    static let chatToProfile = "chatToProfile"
    static let mentorToProfile = "mentorToProfile"
    static let eventToProfile = "eventToProfile"
    static let eventPageEmbed = "eventPageEmbed"
    static let homeToEventDetails = "homeToEventDetails"
    static let homeToChat = "homeToChat"
    static let teamToChat = "teamToChannel"
    static let teamToProfile = "teamToProfile"
    static let profileToChannel = "profileToChannel"
    static let registrationListToRegistration = "registrationListToRegistration"
    static let registrationToProfile = "registrationToProfile"
    static let ideaToProfile = "ideaToProfile"
    static let showDetails = "showDetails"
    static let addIdea = "addIdea"
    static let container = "container"
    static let editIdea = "editIdea"
    static let mentorToTeamInfo = "mentorToTeamInfo"
    
    // Parameters for tableView:
    static let profileCell = "profileCell"
    static let defaultSection = 0
    static let ideaListTableCellHeight: CGFloat = 110
    static let ideaItemCell = "ideaItemCell"

    
    // Parameters for information message:
    static let done = "Done"
    static let noTeamLabel = "No Team yet"
    static let defaultContent = " "
    static let emptyString = ""
    static let ideaCreateErrorMessage = "Sorry, only participants of SWSG can create an idea!"
    static let ideaUserNamePrefix = "by "
    static let deleteIdea = "Delete Idea"
    static let deleteIdeaWarning = "Are you sure to delete this idea?"
    static let no = "No"
    static let yes = "Yes"
    static let emptyIdeaNameError = "Idea name cannot be empty!"
    static let emptyDescriptionError = "Description cannot be empty!"
    static let generalErrorMessage = "Error!"
    static let emailExists = "Already Exists"
    static let logInWithOriginal = "User with Email already exists, please log in with the original client first."
    static let unexpectedError = "An unexpected error has occured"
    static let tryAgain = "Please try again"
    static let communicateFacebook = "Communicating with Facebook"
    static let communicateGoogle = "Communicating with Google"
    static let educationPlaceholder = "(e.g. Computer Science at National University of Singapore)"
    static let skillsPlaceholder = "(e.g. UI/UX Designer)"
    static let descPlaceholder = "Description"
    static let loadingData = "Loading Data..."
    static let addPassword = "Add Password"
    static let changePassword = "Change Password"
    static let userNamePrefix = "@"
    static let removeFacebookTitle = "Removed Facebook"
    static let removeFacebookMessage = "Facebook Login has been removed from your account"
    static let removeGoogleTitle = "Removed Google"
    static let removeGoogleMessage = "Google Login has been removed from your account"
    static let addPasswordMessage = "Please key in your password:"
    static let addButtonText = "Add"
    static let passwordPlaceholder = "Password"
    static let ok = "OK"
    static let cancel = "Cancel"
    static let currentPassword = "Current Password"
    static let newPassword = "New Password"
    static let takePhoto = "Take a photo"
    static let selectPhoto = "Select a photo"
    static let defaultValue: CGFloat = 1
    static let needOverriden = "This method must be overridden"
    static let noCamera = "Sorry, this device has no camera"
    
    static let passwordMinLength = 6
    
    // Parameters for Mentor Booking:
    static var consultationStartTime: Date {
        return Date.time(from: "11:00")
    }
    
    static var consultationEndTime: Date {
        return Date.time(from: "17:00")
    }
    
    static let duration = 60
    static let consultationSlotCell = "consultationSlotCell"
    static let relatedMentorCell = "relatedMentorCell"
    static let slotCollectionTag = 1
    static let relatedCollectionTag = 2
    
    // Parameters for Chat
    static let hourInterval = TimeInterval(3600)
    static let channelsRef = "channels"
    static let channelCell = "channelCell"
    static let memberCell = "memberCell"
    static let isPublic = "isPublic"
    static let messages = "messages"
    static let members = "members"
    static let senderId = "senderId"
    static let senderName = "senderName"
    static let timestamp = "timestamp"
    static let text = "text"
    static let photoURL = "photoURL"
    static let channelType = "channelType"
    static let typingIndicator = "typingIndicator"
    static let channelID = "channelID"
    static let createPublicHeaderLabel = "Create Public Channel"
    static let createPublicMembersHeaderLabel = "Members (Only for Private Channel"
    
    
    // Parameters for Profile
    static let headerFavourites = "Favourites"
    static let headerSearchResults = "Search Results"
    
    //Parameters for storage
    static let commentsFileName = "commentsFileName"
    static let localUser = "localUser"
    
    static let dateTimeFormatDayString = "dd-MM-yyyy"
    
    //Parameters for Firebase Client
    static let users = "users"
    static let me = "me"
    
    //Parameters for Facebook
    static let fbIdentifier = "facebook.com"
    static let emailIdentifier = "email"
    static let googleProfileDimension = UInt(300)
    
    // Parameters for notification:
    static let fullScreenImage = "fullScreenImage"
    static let update = "update"
    static let reload = "reload"
    static let isSuccess = "isSuccess"
    static let videoId = "videoId"
    static let height = "height"
    
    //Parameters for Event
    static let calendarStartDate = Utility.fbDateFormatter.date(from: "01-01-2017")!
    static let calendarEndDate = Utility.fbDateFormatter.date(from: "31-12-2017")!
    static let eventCell = "eventCell"
    static let startDateTime = "startDateTime"
    static let endDateTime = "endDateTime"
    static let shortDesc = "shortDesc"
    
    //Parameters for Registration
    static let registeredUsers = "registeredUsers"
    static let registrationCell = "RegistrationCell"
    static let registeredUserCell = "RegisteredUserCell"
    
    // Other
    static let youtubePrefix = "https://www.youtube.com/embed/"
    static let youtubeIdComponent = 1
}
