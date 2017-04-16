//
//  TeamTests.swift
//  SWSG
//
//  Created by Li Xiaowei on 4/16/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import XCTest
@testable import SWSG

/**
 TeamTests test the class Team
 Testing strategy used: Equivalence Partitions with one case on valid member, and another case on invalid member. 
 If the member does not belong to the team created or the member id is nil, then he is counted as invalid member.
 Valid member means that member id is not nil, and member belong to the team as well.
 
 */

class TeamTests: XCTestCase {

    func testAddMember_validMember_success() {
        let profile1 = Profile(name: "user1", username: "testUser1", image: nil, job: "job1", company: "company1", country: "country1",
                               education: "edu1", skills: "skill1", description: "desc1")
        let profile2 = Profile(name: "user2", username: "testUser2", image: nil, job: "job2", company: "company2", country: "country2",
                               education: "edu2", skills: "skill2", description: "desc2")
        let user1 = User(profile: profile1, type: .init(isParticipant: true, isSpeaker: false, isMentor: false, isOrganizer: false, isAdmin: false), team: Config.noTeam, email: "user1@1.com")
        user1.setUid(uid: "id1")
        let user2 = User(profile: profile2, type: .init(isParticipant: true, isSpeaker: false, isMentor: false, isOrganizer: false, isAdmin: false), team: Config.noTeam, email: "user2@2.com")
        user2.setUid(uid: "id2")
        let team = Team(id: nil, members: [user1.uid!], name: "teamTest", lookingFor: "creative person", isPrivate: true, tags: ["creative","cs"])
        team.addMember(member: user2)
        XCTAssertEqual(team.members.count, 2)
    }
    
    func testAddMember_invalidMember_fail() {
        let profile1 = Profile(name: "user1", username: "testUser1", image: nil, job: "job1", company: "company1", country: "country1",
                               education: "edu1", skills: "skill1", description: "desc1")
        let profile2 = Profile(name: "user2", username: "testUser2", image: nil, job: "job2", company: "company2", country: "country2",
                               education: "edu2", skills: "skill2", description: "desc2")
        let user1 = User(profile: profile1, type: .init(isParticipant: true, isSpeaker: false, isMentor: false, isOrganizer: false, isAdmin: false), team: Config.noTeam, email: "user1@1.com")
        user1.setUid(uid: "id1")
        let user2 = User(profile: profile2, type: .init(isParticipant: true, isSpeaker: false, isMentor: false, isOrganizer: false, isAdmin: false), team: Config.noTeam, email: "user2@2.com")
        let team = Team(id: nil, members: [user1.uid!], name: "teamTest", lookingFor: "creative person", isPrivate: true, tags: ["creative","cs"])
        team.addMember(member: user2)
        XCTAssertEqual(team.members.count, 1)
    }
    
    func testRemoveMember_validMember_success() {
        let profile1 = Profile(name: "user1", username: "testUser1", image: nil, job: "job1", company: "company1", country: "country1",
                               education: "edu1", skills: "skill1", description: "desc1")
        let profile2 = Profile(name: "user2", username: "testUser2", image: nil, job: "job2", company: "company2", country: "country2",
                               education: "edu2", skills: "skill2", description: "desc2")
        let user1 = User(profile: profile1, type: .init(isParticipant: true, isSpeaker: false, isMentor: false, isOrganizer: false, isAdmin: false), team: Config.noTeam, email: "user1@1.com")
        user1.setUid(uid: "id1")
        let user2 = User(profile: profile2, type: .init(isParticipant: true, isSpeaker: false, isMentor: false, isOrganizer: false, isAdmin: false), team: Config.noTeam, email: "user2@2.com")
        user2.setUid(uid: "id2")
        let team = Team(id: nil, members: [user1.uid!, user2.uid!], name: "teamTest", lookingFor: "creative person", isPrivate: true, tags: ["creative","cs"])
        XCTAssertEqual(team.members.count, 2)
        team.removeMember(member: user2)
        XCTAssertEqual(team.members.count, 1)
    }
    
    func testRemoveMember_invalidMember_fail() {
        let profile1 = Profile(name: "user1", username: "testUser1", image: nil, job: "job1", company: "company1", country: "country1",
                               education: "edu1", skills: "skill1", description: "desc1")
        let profile2 = Profile(name: "user2", username: "testUser2", image: nil, job: "job2", company: "company2", country: "country2",
                               education: "edu2", skills: "skill2", description: "desc2")
        let user1 = User(profile: profile1, type: .init(isParticipant: true, isSpeaker: false, isMentor: false, isOrganizer: false, isAdmin: false), team: Config.noTeam, email: "user1@1.com")
        user1.setUid(uid: "id1")
        let user2 = User(profile: profile2, type: .init(isParticipant: true, isSpeaker: false, isMentor: false, isOrganizer: false, isAdmin: false), team: Config.noTeam, email: "user2@2.com")
        user2.setUid(uid: "id2")
        let team = Team(id: nil, members: [user1.uid!], name: "teamTest", lookingFor: "creative person", isPrivate: true, tags: ["creative","cs"])
        team.removeMember(member: user2)
        XCTAssertEqual(team.members.count, 1)
    }
    
    func testContainsMember_validMember_success() {
        let profile1 = Profile(name: "user1", username: "testUser1", image: nil, job: "job1", company: "company1", country: "country1",
                               education: "edu1", skills: "skill1", description: "desc1")
        let profile2 = Profile(name: "user2", username: "testUser2", image: nil, job: "job2", company: "company2", country: "country2",
                               education: "edu2", skills: "skill2", description: "desc2")
        let user1 = User(profile: profile1, type: .init(isParticipant: true, isSpeaker: false, isMentor: false, isOrganizer: false, isAdmin: false), team: Config.noTeam, email: "user1@1.com")
        user1.setUid(uid: "id1")
        let user2 = User(profile: profile2, type: .init(isParticipant: true, isSpeaker: false, isMentor: false, isOrganizer: false, isAdmin: false), team: Config.noTeam, email: "user2@2.com")
        user2.setUid(uid: "id2")
        let team = Team(id: nil, members: [user1.uid!, user2.uid!], name: "teamTest", lookingFor: "creative person", isPrivate: true, tags: ["creative","cs"])
        XCTAssertTrue(team.containsMember(member: user1))
        XCTAssertTrue(team.containsMember(member: user2))
    }
    
    func testContainsMember_invalidMember_fail() {
        let profile1 = Profile(name: "user1", username: "testUser1", image: nil, job: "job1", company: "company1", country: "country1",
                               education: "edu1", skills: "skill1", description: "desc1")
        let profile2 = Profile(name: "user2", username: "testUser2", image: nil, job: "job2", company: "company2", country: "country2",
                               education: "edu2", skills: "skill2", description: "desc2")
        let user1 = User(profile: profile1, type: .init(isParticipant: true, isSpeaker: false, isMentor: false, isOrganizer: false, isAdmin: false), team: Config.noTeam, email: "user1@1.com")
        user1.setUid(uid: "id1")
        let user2 = User(profile: profile2, type: .init(isParticipant: true, isSpeaker: false, isMentor: false, isOrganizer: false, isAdmin: false), team: Config.noTeam, email: "user2@2.com")
        user2.setUid(uid: "id2")
        let team = Team(id: nil, members: [user1.uid!], name: "teamTest", lookingFor: "creative person", isPrivate: true, tags: ["creative","cs"])
        XCTAssertTrue(team.containsMember(member: user1))
        XCTAssertFalse(team.containsMember(member: user2))
    }
    
    func testSetTeamId_success() {
        let profile1 = Profile(name: "user1", username: "testUser1", image: nil, job: "job1", company: "company1", country: "country1",
                               education: "edu1", skills: "skill1", description: "desc1")
        let profile2 = Profile(name: "user2", username: "testUser2", image: nil, job: "job2", company: "company2", country: "country2",
                               education: "edu2", skills: "skill2", description: "desc2")
        let user1 = User(profile: profile1, type: .init(isParticipant: true, isSpeaker: false, isMentor: false, isOrganizer: false, isAdmin: false), team: Config.noTeam, email: "user1@1.com")
        user1.setUid(uid: "id1")
        let user2 = User(profile: profile2, type: .init(isParticipant: true, isSpeaker: false, isMentor: false, isOrganizer: false, isAdmin: false), team: Config.noTeam, email: "user2@2.com")
        user2.setUid(uid: "id2")
        let team = Team(id: nil, members: [user1.uid!], name: "teamTest", lookingFor: "creative person", isPrivate: true, tags: ["creative","cs"])
        XCTAssertEqual(team.id, nil)
        team.setId(id: "teamId")
        XCTAssertEqual(team.id, "teamId")
    }
    
}
