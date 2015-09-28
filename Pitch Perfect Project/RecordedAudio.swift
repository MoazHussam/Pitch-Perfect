//
//  RecordedAudio.swift
//  Pitch Perfect Project
//
//  Created by Moaz on 9/21/15.
//  Copyright © 2015 Moaz Ahmed. All rights reserved.
//

import Foundation

//this class serves as the model as it stores the audio file data
class RecordedAudio {
    

    var filePathUrl: NSURL!
    var fileTitle: NSString!
    
    init(filePathUrl: NSURL!, fileTitle: NSString!) {  
        
        //save file title and location
        self.filePathUrl = filePathUrl
        self.fileTitle = fileTitle        
    }
}
