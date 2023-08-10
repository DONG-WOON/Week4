//
//  Movie.swift
//  Week4
//
//  Created by 서동운 on 8/8/23.
//

import Foundation

// MARK: - Welcome
struct BoxOffice: Codable {
    let boxOfficeResult: BoxOfficeResult
}

// MARK: - BoxOfficeResult
struct BoxOfficeResult: Codable {
    let showRange, boxofficeType: String
    let dailyBoxOfficeList: [Movie]
}

// MARK: - DailyBoxOfficeList
struct Movie: Codable {
    let salesChange, movieCD, salesShare, audiAcc: String
    let openDt, scrnCnt, audiChange, audiInten: String
    let salesAmt, movieNm, showCnt, rnum: String
    let rankOldAndNew: RankOldAndNew
    let rankInten, salesInten, rank, audiCnt: String
    let salesAcc: String

    enum CodingKeys: String, CodingKey {
        case salesChange
        case movieCD = "movieCd"
        case salesShare, audiAcc, openDt, scrnCnt, audiChange, audiInten, salesAmt, movieNm, showCnt, rnum, rankOldAndNew, rankInten, salesInten, rank, audiCnt, salesAcc
    }
}

enum RankOldAndNew: String, Codable {
    case old = "OLD"
}
