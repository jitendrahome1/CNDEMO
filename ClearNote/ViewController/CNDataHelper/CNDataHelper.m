//
//  CNDataHelper.m
//  ClearNote
//
//  Created by Jitendra Agarwal on 01/12/15.
//  Copyright © 2015 Jitendra Agarwal. All rights reserved.
//

#import "CNDataHelper.h"

@implementation CNDataHelper
//*******************************************************************  Master Table Working ************************************************
#pragma mark- work on defult note
+(void)CNdBInsertDefultNoteName:(NSNumber *)defultValue
{
    NSArray * arrResult = nil;
    AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DefultNoteName" inManagedObjectContext:manageObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSError *error1 = nil;
    DefultNoteName *defultNoteName = (DefultNoteName *)[NSEntityDescription insertNewObjectForEntityForName:@"DefultNoteName" inManagedObjectContext:manageObjectContext];
    if(defultNoteName)
    {
        
        defultNoteName.autoIncrementValue = defultValue;
        NSError * err = nil;
        [manageObjectContext save:&err];
    }
    
}
+(NSArray *)CNdBFetchDefultNoteName
{
    NSArray *arrNote = nil;;
    AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DefultNoteName" inManagedObjectContext:manageObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSError *error1 = nil;
    arrNote = [app.managedObjectContext executeFetchRequest:request error:&error1];
    return arrNote;
    
}
#pragma mark- check User authentication
+(NSArray *)CNdBAuthenticateUser:(NSString *)email userPassword:(NSString *)userPassword
{
    NSArray * arrResult = nil;
    AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:manageObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email = %@ AND userPassword = %@",email,userPassword];
    [request setPredicate:predicate];
    NSError *error1 = nil;
    arrResult = [app.managedObjectContext executeFetchRequest:request error:&error1];
    return arrResult;
}
#pragma mark- Insert user Record when login is success and update.
#pragma mark- insert record
+(void)CNdBInsertUserDetailsWithUserID:(NSString *)userID userName:(NSString *)userName userPassword:(NSString *)userPassword email:(NSString *)email
{
    NSArray * arrResult = nil;
    AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:manageObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID = %@",userID];
    [request setPredicate:predicate];
    NSError *error1 = nil;
    arrResult = [app.managedObjectContext executeFetchRequest:request error:&error1];
    if(arrResult.count==0 || !arrResult)
    {
        Users *objUser = (Users *)[NSEntityDescription insertNewObjectForEntityForName:@"Users" inManagedObjectContext:manageObjectContext];
        if(objUser)
        {
            objUser.userName = userName;
            objUser.email = email;
            objUser.userPassword = userPassword;
            objUser.userID = userID;
            NSError * err = nil;
            [manageObjectContext save:&err];
        }
    }
    else
    {
        Users *objUserDetails = (Users *)[arrResult lastObject];
        if(objUserDetails)
        {
            objUserDetails.userName = userName;
            objUserDetails.email = email;
            objUserDetails.userPassword = userPassword;
            NSError * err = nil;
            [manageObjectContext save:&err];
        }
    }
}
#pragma mark- create a new note
+(MasterNote*)CNdBCreateNewNotewithUserID:(NSString *)userID noteCreateID:(NSString *)noteCreateID noteTitle:(NSString *)noteTitle isDeleted:(NSString *)isDeleted content:(NSString *)content noteCreateDate:(NSString *)noteCreateDate isSynchoronization:(NSString *)isSynchoronization tempNoteID:(NSString *)tempNoteID
{
    
      NSString* timeStampLocal = [[CNHelper sharedInstance]gettimestampStringFroLocalTime];
    //    NSString * tempNoteID = nil;
    //    tempNoteID = [[CNHelper sharedInstance]gettimestampStringFroLocalTime];
    AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
    MasterNote *_objMasterTable = (MasterNote *)[NSEntityDescription insertNewObjectForEntityForName:@"MasterNote" inManagedObjectContext:manageObjectContext];
    if([isSynchoronization isEqualToString:@"0"])   // if net is not working
    {
        [self oflineCreateNoteWithUserID:userID noteCreateID:noteCreateID noteName:noteTitle content:content timeStamp:noteCreateDate noteCreateDate:noteCreateDate isDeleted:isDeleted tempUserId:tempNoteID isSynchoronization:isSynchoronization];
    }
    if(_objMasterTable)
    {
        if(noteCreateID.length > 0)
        {
            tempNoteID = @"";
        }
        _objMasterTable.userID = userID;
        _objMasterTable.noteCreateID = noteCreateID;
        _objMasterTable.noteCreateDate = noteCreateDate;
        _objMasterTable.isdeleted = [NSNumber numberWithInt:[isDeleted intValue]];
        _objMasterTable.noteName = noteTitle;
        _objMasterTable.tempUserId = tempNoteID;
        _objMasterTable.fileData = content;
        _objMasterTable.isSynchoronization = [NSNumber numberWithInt:[isSynchoronization intValue]];
        //  _objMasterTable.timestamp = noteCreateDate;
        //chnage 4-2-2016
        _objMasterTable.timestamp = noteCreateDate;
        //end
        
        NSError * err = nil;
        [manageObjectContext save:&err];
    }
    return _objMasterTable;
}




// Again update the note id id exceptin is occer,
+(void)CNCreteAgainNotewithUserID:(NSString *)userID noteCreateID:(NSString *)noteCreateID noteTitle:(NSString *)noteTitle isDeleted:(NSString *)isDeleted content:(NSString *)content noteCreateDate:(NSString *)noteCreateDate isSynchoronization:(NSString *)isSynchoronization tempNoteID:(NSString *)tempNoteID
{
    NSArray * arrResult = nil;
    AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MasterNote" inManagedObjectContext:manageObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
  NSPredicate *predicate = [[NSPredicate alloc]init];
    [request setEntity:entity];
    


    if([noteCreateID length ] > 0)
    {
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND timestamp = %@",userID,tempNoteID];
    }
    [request setPredicate:predicate];
    NSError *error1 = nil;
    arrResult = [app.managedObjectContext executeFetchRequest:request error:&error1];
    if(arrResult.count==0 || !arrResult)
    {
    }
    
    // update
    else
    {
          tempNoteID = @"";
        MasterNote *_objMasterTable = [arrResult lastObject];
        _objMasterTable.userID = userID;
        _objMasterTable.noteCreateID = noteCreateID;
        _objMasterTable.noteCreateDate = noteCreateDate;
        _objMasterTable.isdeleted = [NSNumber numberWithInt:[isDeleted intValue]];
        _objMasterTable.noteName = noteTitle;
        _objMasterTable.tempUserId = tempNoteID;
        _objMasterTable.fileData = content;
        _objMasterTable.isSynchoronization = [NSNumber numberWithInt:[isSynchoronization intValue]];
          _objMasterTable.timestamp = noteCreateDate;
        NSError * err = nil;
        [manageObjectContext save:&err];
    }
    
    
    
}


#pragma mark- check note Id alredy exist
+(void)CNdBNoteAlredyExistWithUserId:(NSString *)userID noteCreateID:(NSString *)noteCreateID noteTitle:(NSString *)noteTitle isDeleted:(NSString *)isDeleted content:(NSString *)content noteCreateDate:(NSString *)noteCreateDate isSynchoronization:(NSString *)isSynchoronization
{
    NSArray * arrResult = nil;
    AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MasterNote" inManagedObjectContext:manageObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
   
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND noteCreateID = %@",userID,noteCreateID];
    
    
    [request setPredicate:predicate];
    NSError *error1 = nil;
    arrResult = [app.managedObjectContext executeFetchRequest:request error:&error1];
    if(arrResult.count==0 || !arrResult)
    {
        // insert the new record
        
        MasterNote *_objMasterTable = (MasterNote *)[NSEntityDescription insertNewObjectForEntityForName:@"MasterNote" inManagedObjectContext:manageObjectContext];
        _objMasterTable.userID = userID;
        _objMasterTable.noteCreateID = noteCreateID;
        _objMasterTable.noteCreateDate = noteCreateDate;
        _objMasterTable.isdeleted = [NSNumber numberWithInt:[isDeleted intValue]];
        _objMasterTable.noteName = noteTitle;
        _objMasterTable.fileData = content;
        _objMasterTable.timestamp = noteCreateDate;
        _objMasterTable.isSynchoronization = [NSNumber numberWithInt:[isSynchoronization intValue]];
        NSError * err = nil;
        [manageObjectContext save:&err];
    }
    else
    {
        if([isDeleted isEqualToString:@"-1"])
        {
            for(NSManagedObject *delete in arrResult)
            {
                [app.managedObjectContext deleteObject:delete];
            }
            [app.managedObjectContext save:&error1];
            // flush out
        }
        else
        {     // update the record
            MasterNote *_objMasterTable = [arrResult lastObject];
            _objMasterTable.isdeleted = [NSNumber numberWithInt:[isDeleted intValue]];
            _objMasterTable.noteName = noteTitle;
            _objMasterTable.fileData = content;
            _objMasterTable.isSynchoronization = [NSNumber numberWithInt:[isSynchoronization intValue]];
            NSError * err = nil;
            [manageObjectContext save:&err];
        }
        
    }
}

#pragma mark- Trash And Delete Queary
#pragma mark- note Move To Trash
+(void)CNdBMoveTrashWithUserID:(NSString *)userID noteCreateID:(NSString *)noteCreateID isDeleted:(NSString *)isDeleted noteName:(NSString *)noteName tempUserId:(NSString *)tempUserId noteCreateDate:(NSString *)noteCreateDate fileData:(NSString *)fileData timeStamp:(NSString *)timeStamp isSynchoronization:(NSString *)isSynchoronization
{
    NSArray * arrResult = nil;
    NSPredicate *predicate = [[NSPredicate alloc]init];
    if([isSynchoronization  isEqualToString:@"0"])   // if net is offline
    {
//        [self oflineUpdateMoveTrashNoteStatuswithUserID:userID tempUserId:tempUserId noteName:noteName noteID:noteCreateID isDeleted:isDeleted isSynchoronization:isSynchoronization];
        
        
        
        [self oflineUpdateMoveTrashNoteStatuswithUserID:userID tempUserId:tempUserId noteName:noteName noteID:noteCreateID noteCreateDate:noteCreateDate fileData:fileData timeStamp:timeStamp isDeleted:isDeleted isSynchoronization:isSynchoronization];
        
        
    
//        [self oflineCreateNoteUpdateWithUserID:userID noteCreateID:noteCreateID IsDelete:isDeleted noteName:noteName tempUserId:tempUserId];
        
        [self oflineCreateNoteUpdateWithUserID:userID noteCreateID:noteCreateID noteCreateDate:noteCreateDate fileData:fileData timeStamp:timeStamp IsDelete:isDeleted noteName:noteName tempUserId:tempUserId];
     
//          [self oflineCreateWriteContextUpdateWithUserID:userID noteCreateID:noteCreateID IsDelete:isDeleted noteName:noteName tempUserId:tempUserId];
        
        [self oflineCreateWriteContextUpdateWithUserID:userID noteCreateID:noteCreateID noteCreateDate:noteCreateDate fileData:fileData timeStamp:timeStamp IsDelete:isDeleted noteName:noteName tempUserId:tempUserId];
        
    
    [self flashOutCreateRestorenoteOflineTablewithUserID:userID noteID:noteCreateID tempUserId:tempUserId];
        
        
        if(noteCreateID.length > 0)
        {
            predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND noteCreateID = %@",userID,noteCreateID];
            
        }
        else
        {
            predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND tempUserId = %@",userID,tempUserId];
            
        }
        AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"MasterNote" inManagedObjectContext:manageObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        [request setEntity:entity];
        [request setPredicate:predicate];
        NSError *error1 = nil;
        arrResult = [app.managedObjectContext executeFetchRequest:request error:&error1];
        MasterNote *objNote = (MasterNote *)[arrResult lastObject];
        objNote.isdeleted = [NSNumber numberWithInt:[isDeleted intValue]];
        objNote.isSynchoronization = [NSNumber numberWithInt:[isSynchoronization intValue]];
        objNote.noteName = noteName;
        objNote.fileData = fileData;
        
        NSError * err = nil;
        [manageObjectContext save:&err];
    }
    else
    {
        AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"MasterNote" inManagedObjectContext:manageObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        [request setEntity:entity];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND noteCreateID = %@",userID,noteCreateID];
        [request setPredicate:predicate];
        NSError *error1 = nil;
        arrResult = [app.managedObjectContext executeFetchRequest:request error:&error1];
        MasterNote *objNote = (MasterNote *)[arrResult lastObject];
        objNote.isdeleted = [NSNumber numberWithInt:[isDeleted intValue]];
        objNote.noteName = noteName;
        objNote.fileData = fileData;
        objNote.isSynchoronization = [NSNumber numberWithInt:[isSynchoronization intValue]];
        NSError * err = nil;
        [manageObjectContext save:&err];
    }
}
#pragma mark- Restore Note
+(void)CNdBRestoreNoteWithUserID:(NSString *)userID noteCreateID:(NSString *)noteCreateID isDeleted:(NSString *)isDeleted noteName:(NSString *)noteName noteCreateDate:(NSString *)noteCreateDate fileData:(NSString *)fileData timeStamp:(NSString *)timeStamp tempUserId:(NSString *)tempUserId isSynchoronization:(NSString *)isSynchoronization
{
    NSArray * arrResult = nil;
    NSPredicate *predicate = [[NSPredicate alloc]init];
    if([isSynchoronization  isEqualToString:@"0"])   // if net is offline
    {
[self oflineRestoreNoteWithUserID:userID tempUserId:tempUserId noteID:noteCreateID isDeleted:isDeleted noteCreateDate:noteCreateDate fileData:fileData timeStamp:timeStamp noteName:noteName isSynchoronization:isSynchoronization];
        
        // chnage 18-2-2016
      // [self oflineCreateNoteUpdateWithUserID:userID noteCreateID:noteCreateID IsDelete:isDeleted noteName:noteName tempUserId:tempUserId];
        
 [self oflineCreateNoteUpdateWithUserID:userID noteCreateID:noteCreateID noteCreateDate:noteCreateDate fileData:fileData timeStamp:timeStamp IsDelete:isDeleted noteName:noteName tempUserId:tempUserId];
        
        
        [self oflineCreateWriteContextUpdateWithUserID:userID noteCreateID:noteCreateID noteCreateDate:noteCreateDate fileData:fileData timeStamp:timeStamp IsDelete:isDeleted noteName:noteName tempUserId:tempUserId];
        
        if(noteCreateID.length > 0)
        {
            predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND noteCreateID = %@",userID,noteCreateID];
            [self flashOutCreateTemporaryDeleteTableWithUserID:userID noteID:noteCreateID tempUserId:tempUserId];
            
        }
        else
        {
            predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND tempUserId = %@",userID,tempUserId];
            [self flashOutCreateTemporaryDeleteTableWithUserID:userID noteID:noteCreateID tempUserId:tempUserId];
        }
        
        AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"MasterNote" inManagedObjectContext:manageObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        [request setEntity:entity];
        [request setPredicate:predicate];
        NSError *error1 = nil;
        arrResult = [app.managedObjectContext executeFetchRequest:request error:&error1];
        MasterNote *objNote = (MasterNote *)[arrResult lastObject];
        objNote.isdeleted = [NSNumber numberWithInt:[isDeleted intValue]];
        objNote.isSynchoronization = [NSNumber numberWithInt:[isSynchoronization intValue]];
        NSError * err = nil;
        [manageObjectContext save:&err];
        
    }
    else
    {
        // net working
        AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"MasterNote" inManagedObjectContext:manageObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        [request setEntity:entity];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND noteCreateID = %@",userID,noteCreateID];
        [request setPredicate:predicate];
        NSError *error1 = nil;
        arrResult = [app.managedObjectContext executeFetchRequest:request error:&error1];
        MasterNote *objNote = (MasterNote *)[arrResult lastObject];
        objNote.isdeleted = [NSNumber numberWithInt:[isDeleted intValue]];
         objNote.isSynchoronization = [NSNumber numberWithInt:[isSynchoronization intValue]];
        NSError * err = nil;
        [manageObjectContext save:&err];
    }
}



#pragma mark- Delete Note Permanently
+(void)CNdBDeleteNotePermanentlyWithuserID:(NSString *)userID noteCreateID:(NSString *)noteCreateID noteName:(NSString *)noteName  noteCreateDate:(NSString *)noteCreateDate fileData:(NSString *)fileData timeStamp:(NSString *)timeStamp tempUserId:(NSString *)tempUserId isSynchoronization:(NSString *)isSynchoronization
{
    NSArray * arrResult = nil;
    if([isSynchoronization isEqualToString:@"0"]) // net is not working
    {
        [self flashOutCreateTemporaryDeleteTableWithUserID:userID noteID:noteCreateID tempUserId:tempUserId];
        [self flashOutCreateRestorenoteOflineTablewithUserID:userID noteID:noteCreateID tempUserId:tempUserId];
        [self flashOutCreateNoteContentOfflineTableWithUserID:userID noteID:noteCreateID  tempUserId:tempUserId];
        [self flashOutCreateNoteOflinetOfflineTableWithUserID:userID noteID:noteCreateID  tempUserId:tempUserId];
        if(noteCreateID.length > 0)
        {
//            [self oflineInsertDeletedPermanentDeleteWithUserID:userID tempUserId:tempUserId noteID:noteCreateID isDeleted:@"-1" noteName:noteName isSynchoronization:isSynchoronization];
            
            [self oflineInsertDeletedPermanentDeleteWithUserID:userID tempUserId:tempUserId noteID:noteCreateID noteCreateDate:noteCreateDate fileData:fileData timeStamp:timeStamp isDeleted:@"-1" noteName:noteName isSynchoronization:isSynchoronization];
            [self flashOutNoteUserID:userID noteCreateID:noteCreateID];
        }
        else
        {
            AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
            NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"MasterNote" inManagedObjectContext:manageObjectContext];
            NSFetchRequest *request = [[NSFetchRequest alloc]init];
            [request setEntity:entity];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND tempUserId = %@",userID,tempUserId];
            [request setPredicate:predicate];
            NSError *error1 = nil;
            arrResult = [app.managedObjectContext executeFetchRequest:request error:&error1];
            for(NSManagedObject *delete in arrResult)
            {
                [app.managedObjectContext deleteObject:delete];
            }
            [app.managedObjectContext save:&error1];
            
        }
    }
    else
    {
        AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"MasterNote" inManagedObjectContext:manageObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        [request setEntity:entity];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND noteCreateID = %@",userID,noteCreateID];
        [request setPredicate:predicate];
        NSError *error1 = nil;
        arrResult = [app.managedObjectContext executeFetchRequest:request error:&error1];
        for(NSManagedObject *delete in arrResult)
        {
            [app.managedObjectContext deleteObject:delete];
        }
        [app.managedObjectContext save:&error1];
    }
}
#pragma mark- Upate Note Wrting Contant and note name
//+(void)CNdBWrtingAndEditNoteWithUserId:(NSString *)userID noteCreateID:(NSString *)noteCreateID tempUserId:(NSString *)tempUserId contant:(NSString *)contant noteName:(NSString *)noteName isSynchoronization:(NSString *)isSynchoronization
//{
+(void)CNdBWrtingAndEditNoteWithUserId:(NSString *)userID noteCreateID:(NSString *)noteCreateID tempUserId:(NSString *)tempUserId contant:(NSString *)contant noteName:(NSString *)noteName updateNoteDateTime:(NSString *)updateNoteDateTime isDeleted:(NSString *)isDeleted timeStamp:(NSString *)timeStamp noteCreateDate:(NSString *)noteCreateDate isSynchoronization:(NSString *)isSynchoronization
    {
    if([isSynchoronization isEqualToString:@"0"]) // net is not working
    {

[self oflineCreateWriteContextOfflineWithUserID:userID noteID:noteCreateID tempUserId:tempUserId contant:contant noteName:noteName timeStamp:updateNoteDateTime isDeleted:isDeleted noteCreateDate:noteCreateDate isSynchoronization:isSynchoronization];
        
     // Restore Update
 [self oflineRestoreNoteUpdateWithUserID:userID noteCreateID:noteCreateID noteCreateDate:noteCreateDate fileData:contant timeStamp:timeStamp IsDelete:isDeleted noteName:noteName tempUserId:tempUserId];
       
      
[self oflineCreateNoteUpdateWithUserID:userID noteCreateID:noteCreateID noteCreateDate:noteCreateDate fileData:contant timeStamp:timeStamp IsDelete:isDeleted noteName:noteName tempUserId:tempUserId];
        
        //end
        
[self updateContextWithUserID:[CNHelper sharedInstance].userLoginID noteCreateID:noteCreateID contant:contant tempNoteID:tempUserId noteName:noteName noteCreateDate:noteCreateDate isDeleted:isDeleted updateNoteDateTime:updateNoteDateTime isSynchoronization:isSynchoronization];
    }
    else
    {
        [self updateContextWithUserID:[CNHelper sharedInstance].userLoginID noteCreateID:noteCreateID contant:contant tempNoteID:tempUserId noteName:noteName noteCreateDate:noteCreateDate isDeleted:isDeleted updateNoteDateTime:updateNoteDateTime isSynchoronization:isSynchoronization];
    }
}
#pragma update in master table note contant
#pragma mark- Update Context in note Table
//+(void)updateContextWithUserID:(NSString *)userID noteCreateID: (NSString *)noteCreateID contant:(NSString *)contant tempNoteID:(NSString *)tempNoteID noteName:(NSString *)noteName isSynchoronization:(NSString *)isSynchoronization
//{
+(void)updateContextWithUserID:(NSString *)userID noteCreateID: (NSString *)noteCreateID contant:(NSString *)contant tempNoteID:(NSString *)tempNoteID noteName:(NSString *)noteName  noteCreateDate:(NSString *)noteCreateDate isDeleted:(NSString *)isDeleted updateNoteDateTime:(NSString *)updateNoteDateTime isSynchoronization:(NSString *)isSynchoronization
    {
       //NSString * timeStampLocal = [[CNHelper sharedInstance]gettimestampStringFroLocalTime];
    NSArray * arrResult = nil;
    AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MasterNote" inManagedObjectContext:manageObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSPredicate *predicate = [[NSPredicate alloc]init];
    if([isSynchoronization isEqualToString:@"0"])
    {
        if(noteCreateID.length > 0)
        {
            predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND noteCreateID = %@",userID,noteCreateID];
        }
        else
        {
            predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND tempUserId = %@",userID,tempNoteID];
        }
        
        
        if(tempNoteID.length == 0)
        {
            predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND noteCreateDate = %@",userID,noteCreateDate];
            tempNoteID = [[CNHelper sharedInstance]gettimestampStringFroLocalTime];
            
        }
        
    }
    else
    {
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND noteCreateID = %@",userID,noteCreateID];
    }
    
    [request setPredicate:predicate];
    NSError *error1 = nil;
    arrResult = [app.managedObjectContext executeFetchRequest:request error:&error1];
    if(arrResult.count == 0 || !arrResult)
    {
    }
    else
    {
        // update
        MasterNote *_objNote = (MasterNote *)[arrResult lastObject];
        _objNote.noteCreateID = noteCreateID ;
        _objNote.fileData = contant;
        _objNote.noteName = noteName;
        _objNote.isSynchoronization = [NSNumber numberWithInt:[isSynchoronization intValue]];
       // _objNote.noteCreateDate = updateNoteDateTime;
        
        _objNote.noteCreateDate = noteCreateDate;
        _objNote.tempUserId  = tempNoteID;
     
         //  _objNote.timestamp = timeStampLocal;
        //chnage 4-2-2016
          _objNote.timestamp = updateNoteDateTime;
        //end
     
        NSError * err = nil;
        [manageObjectContext save:&err];
    }
}

#pragma mark- Flash Out Mater Note table
+(void)flashOutNoteUserID:(NSString *)userID noteCreateID:(NSString *)noteCreateID
{
    NSLog(@"%@",noteCreateID);
    NSArray * arrResult = nil;
    AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MasterNote" inManagedObjectContext:manageObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND noteCreateID = %@",userID,noteCreateID];
    [request setPredicate:predicate];
    NSError *error1 = nil;
    arrResult = [app.managedObjectContext executeFetchRequest:request error:&error1];
    for(NSManagedObject *delete in arrResult)
    {
        [app.managedObjectContext deleteObject:delete];
    }
    [app.managedObjectContext save:&error1];
}

#pragma mark- Flash out
#pragma flash out MasterNote table note table
+(void)flashOutAllRecordsMasterNote:(NSString*)tableName userID:(NSString *)userID
{
    AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:manageObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND isdeleted = %@",userID,@"1"];
    [request setPredicate:predicate];
    NSError *error1 = nil;
    NSArray *items = [app.managedObjectContext executeFetchRequest:request error:&error1];
    for (NSManagedObject *obj in items)
    {
        [app.managedObjectContext deleteObject:obj];
    }
    NSError *error = nil;
    [app.managedObjectContext save:&error];
}

#pragma mark - Delete All Records (Any Table)
#pragma mark -
// Flush all the Records from the given tableName.
+(void)removeAllRecordsFromTable:(NSString*)tableName
{
    AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:manageObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSError *error1 = nil;
    NSArray *items = [app.managedObjectContext executeFetchRequest:request error:&error1];
    for (NSManagedObject *obj in items)
    {
        [app.managedObjectContext deleteObject:obj];
    }
    NSError *error = nil;
    [app.managedObjectContext save:&error];
}

#pragma mark- Fetch Queary
#pragma mark- get All note
+(NSArray *)CNdBGetAllNoteWithUserID:(NSString *)userID isdeleValue:(NSString *)isdeleValue

{   NSArray *arrNote = nil;;
    AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MasterNote" inManagedObjectContext:manageObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND isdeleted = %@",userID , isdeleValue];
    [request setPredicate:predicate];
    NSError *error1 = nil;
    
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"timestamp"
                                                                    ascending:NO];
    
    [request setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor1,nil]];
    
    arrNote = [app.managedObjectContext executeFetchRequest:request error:&error1];

    return arrNote;
}

//*******************************************************************  End Master Table Working ************************************************************


//*******************************************************************  Ofline table Working ********************************************************************
#pragma mark-
#pragma mark- Ofline Table create
#pragma mark- Create A note if user ofline
+(void)oflineCreateNoteWithUserID:userID noteCreateID:noteCreateID noteName:noteTitle content:(NSString *)content timeStamp:(NSString*)timeStamp noteCreateDate:(NSString *)noteCreateDate isDeleted:isDeleted tempUserId:tempUserId isSynchoronization:isSynchoronization
{
    NSArray * arrResult = nil;
    AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CreateNoteOfline" inManagedObjectContext:manageObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
NSPredicate *predicate =[[NSPredicate alloc]init];
    [request setEntity:entity];
    
    

    
  
    
    // chnage 2-1-2016
 if([noteCreateID length ] == 0)
    {
    predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND tempUserID = %@",userID,tempUserId];
    }
    else
    {
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND noteCreateID = %@",userID,noteCreateID];
        
    }
    


    // end
    
    [request setPredicate:predicate];
    
    NSError *error1 = nil;
    arrResult = [app.managedObjectContext executeFetchRequest:request error:&error1];
    if(arrResult.count == 0 || !arrResult)
    {
        CreateNoteOfline *_objCrtNote = (CreateNoteOfline *)[NSEntityDescription insertNewObjectForEntityForName:@"CreateNoteOfline" inManagedObjectContext:manageObjectContext];
        if(_objCrtNote)
        {
            _objCrtNote.userID = userID;
            _objCrtNote.noteCreateID = noteCreateID;
            _objCrtNote.isdeleted = [NSNumber numberWithInt:[isDeleted intValue]];
            _objCrtNote.isSynchoronization = [NSNumber numberWithInt:[isSynchoronization intValue]];
            _objCrtNote.tempUserID = tempUserId;
            _objCrtNote.noteName = noteTitle;
            _objCrtNote.fileData = content;
            _objCrtNote.noteCreateDate = noteCreateDate;
            //chnage  4-2-2016
             _objCrtNote.timestamp = timeStamp;
            //emd
            NSError * err = nil;
            [manageObjectContext save:&err];
        }
    }
    else{
        CreateNoteOfline *_objCrtNote = (CreateNoteOfline *)[arrResult lastObject];
        
        if(_objCrtNote)
        {
            _objCrtNote.isdeleted = [NSNumber numberWithInt:[isDeleted intValue]];
            
            // chnage 28-1-2016
            _objCrtNote.userID = userID;
            _objCrtNote.noteCreateID = noteCreateID;
            _objCrtNote.isSynchoronization = [NSNumber numberWithInt:[isSynchoronization intValue]];
            _objCrtNote.tempUserID = tempUserId;
            _objCrtNote.noteName = noteTitle;
            _objCrtNote.fileData = content;
            //chnage  4-2-2016
            _objCrtNote.timestamp = timeStamp;
            //emd
            // end
            
            NSError * err = nil;
            [manageObjectContext save:&err];
        }
    }
}
//update
+(void)oflineCreateNoteUpdateWithUserID:userID noteCreateID:noteCreateID noteCreateDate:(NSString *)noteCreateDate fileData:(NSString *)fileData timeStamp:(NSString *)timeStamp IsDelete:(NSString *)IsDelete noteName:(NSString *)noteName tempUserId:tempUserId
{
    NSArray * arrResult = nil;
    AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CreateNoteOfline" inManagedObjectContext:manageObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSPredicate *predicate =[[NSPredicate alloc]init];
    [request setEntity:entity];
    // chnage 2-1-2016
    if([noteCreateID length ] == 0)
    {
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND tempUserID = %@",userID,tempUserId];
    }
    else
    {
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND noteCreateID = %@",userID,noteCreateID];
        
    }
    [request setPredicate:predicate];
    
    NSError *error1 = nil;
    arrResult = [app.managedObjectContext executeFetchRequest:request error:&error1];
    if(arrResult.count == 0 || !arrResult)
    {
    }
    else
    {
        CreateNoteOfline *_objCrtNote = (CreateNoteOfline *)[arrResult lastObject];
        
        if(_objCrtNote)
        {
            _objCrtNote.isdeleted = [NSNumber numberWithInt:[IsDelete intValue]];
            _objCrtNote.noteName = noteName;
            
            _objCrtNote.fileData= fileData;
            _objCrtNote.tempUserID = tempUserId;
            _objCrtNote.timestamp = timeStamp;
            _objCrtNote.noteCreateDate = noteCreateDate;
            

            

    }
    }
    
}

+(void)oflineRestoreNoteUpdateWithUserID:userID noteCreateID:noteCreateID noteCreateDate:(NSString *)noteCreateDate fileData:(NSString *)fileData timeStamp:(NSString *)timeStamp IsDelete:(NSString *)IsDelete noteName:(NSString *)noteName tempUserId:tempUserId
{
    NSArray * arrResult = nil;
    AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CreateRestoreOfline" inManagedObjectContext:manageObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSPredicate *predicate =[[NSPredicate alloc]init];
    [request setEntity:entity];
    // chnage 2-1-2016
    if([noteCreateID length ] == 0)
    {
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND tempUserId = %@",userID,tempUserId];
    }
    else
    {
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND noteCreateID = %@",userID,noteCreateID];
        
    }
    [request setPredicate:predicate];
    
    NSError *error1 = nil;
    arrResult = [app.managedObjectContext executeFetchRequest:request error:&error1];
    if(arrResult.count == 0 || !arrResult)
    {
    }
    else
    {
        CreateRestoreOfline *_objCrtNote = (CreateRestoreOfline *)[arrResult lastObject];
        
        if(_objCrtNote)
        {
            _objCrtNote.isdeleted = [NSNumber numberWithInt:[IsDelete intValue]];
            _objCrtNote.noteName = noteName;
            
            _objCrtNote.fileData= fileData;
            _objCrtNote.tempUserId = tempUserId;
            _objCrtNote.timestamp = timeStamp;
            _objCrtNote.noteCreateDate = noteCreateDate;
            
            
            
            
        }
    }
    
}




#pragma mark- Create A note if user ofline
+(void)oflineCreateNoteUpdateWithUserID:userID noteCreateID:noteCreateID noteName:noteTitle content:(NSString *)content timeStamp:(NSString *)timeStamp noteCreateDate:(NSString *)noteCreateDate isDeleted:isDeleted tempUserId:tempUserId isSynchoronization:isSynchoronization
{
    NSArray * arrResult = nil;
    AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CreateNoteOfline" inManagedObjectContext:manageObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSPredicate *predicate =[[NSPredicate alloc]init];
    [request setEntity:entity];
    // chnage 2-1-2016
    if([noteCreateID length ] == 0)
    {
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND tempUserID = %@",userID,tempUserId];
    }
    else
    {
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND noteCreateID = %@",userID,noteCreateID];
        
    }
    // end
    
    [request setPredicate:predicate];
    
    NSError *error1 = nil;
    arrResult = [app.managedObjectContext executeFetchRequest:request error:&error1];
    if(arrResult.count == 0 || !arrResult)
    {
    }
//        CreateNoteOfline *_objCrtNote = (CreateNoteOfline *)[NSEntityDescription insertNewObjectForEntityForName:@"CreateNoteOfline" inManagedObjectContext:manageObjectContext];
//        if(_objCrtNote)
//        {
////            _objCrtNote.userID = userID;
////            _objCrtNote.noteCreateID = noteCreateID;
////            _objCrtNote.isdeleted = [NSNumber numberWithInt:[isDeleted intValue]];
////            _objCrtNote.isSynchoronization = [NSNumber numberWithInt:[isSynchoronization intValue]];
////            _objCrtNote.tempUserID = tempUserId;
////            _objCrtNote.noteName = noteTitle;
////            _objCrtNote.fileData = content;
////            NSError * err = nil;
////            [manageObjectContext save:&err];
//        }
    
    else{
        CreateNoteOfline *_objCrtNote = (CreateNoteOfline *)[arrResult lastObject];
        
        if(_objCrtNote)
        {
            _objCrtNote.isdeleted = [NSNumber numberWithInt:[isDeleted intValue]];
            
            // chnage 28-1-2016
            _objCrtNote.userID = userID;
            _objCrtNote.noteCreateID = noteCreateID;
            _objCrtNote.isSynchoronization = [NSNumber numberWithInt:[isSynchoronization intValue]];
            _objCrtNote.tempUserID = tempUserId;
            _objCrtNote.noteName = noteTitle;
            _objCrtNote.fileData = content;
            _objCrtNote.noteCreateDate = noteCreateDate;
            
            // chnage 4 - 2- 2016
            _objCrtNote.timestamp = timeStamp;
            //end
            // end
            
            NSError * err = nil;
            [manageObjectContext save:&err];
        }
    }
}



#pragma mark-  write context offline table CreateNoteContentOffline
+(void)oflineCreateWriteContextOfflineWithUserID:(NSString *)userID noteID:(NSString *)noteID tempUserId:(NSString *)tempUserId contant:(NSString*)contant noteName:(NSString *)noteName timeStamp:(NSString *)timeStamp isDeleted:(NSString *)isDeleted noteCreateDate:(NSString *)noteCreateDate isSynchoronization:(NSString *)isSynchoronization
{
    NSArray * arrResult;
    AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CreateNoteContentOffline" inManagedObjectContext:manageObjectContext];
    NSPredicate *predicate = [[NSPredicate alloc]init];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    
    if(noteID.length > 0)
    {
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND noteCreateID = %@",userID,noteID];
    }
    else
    {
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND tempUserId = %@",userID,tempUserId];
    }
    
 
 
    [request setPredicate:predicate];
    NSError *error1 = nil;
    arrResult = [app.managedObjectContext executeFetchRequest:request error:&error1];
    if(arrResult.count == 0 || !arrResult)
    {
        CreateNoteContentOffline *_objWriteContext = (CreateNoteContentOffline *)[NSEntityDescription insertNewObjectForEntityForName:@"CreateNoteContentOffline" inManagedObjectContext:manageObjectContext];
        if(_objWriteContext)
        {
            _objWriteContext.userID = userID;
            _objWriteContext.noteCreateID = noteID;
            _objWriteContext.tempUserId = tempUserId;
            _objWriteContext.noteName = noteName;
            _objWriteContext.isSynchoronization = [NSNumber numberWithInt:[isSynchoronization intValue]];
            _objWriteContext.content =contant;
            _objWriteContext.isdeleted = [NSNumber numberWithInt:[isDeleted intValue]];
            _objWriteContext.noteCreateDate = noteCreateDate;
            // chnage 4 -2-2016n
            _objWriteContext.timestamp = timeStamp;

            //end
        }
        
        NSError * err = nil;
        [manageObjectContext save:&err];
    }
    else
    {
        // update
        CreateNoteContentOffline *_objWriteContext = [arrResult lastObject];
        if(_objWriteContext)
        {
            _objWriteContext.content = contant;
            _objWriteContext.noteName = noteName;
            // chnage 4 -2-2016
            _objWriteContext.timestamp = timeStamp;
            _objWriteContext.isdeleted = [NSNumber numberWithInt:[isDeleted intValue]];
            _objWriteContext.noteCreateDate = noteCreateDate;
        
            //end
            NSError * err = nil;
            [manageObjectContext save:&err];
            
        }
        
    }
    
}
#pragma mark- ofline table insert or update in create table
+(void)oflineUpdateMoveTrashNoteStatuswithUserID:(NSString *)userID tempUserId:(NSString *)tempUserId noteName:(NSString *)noteName noteID:(NSString *)noteID noteCreateDate:(NSString *)noteCreateDate fileData:(NSString *)fileData timeStamp:(NSString *)timeStamp isDeleted:(NSString *)isDeleted isSynchoronization:(NSString *)isSynchoronization
{
    NSArray *arrResult = nil;
    AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CreateTemporaryDelete" inManagedObjectContext:manageObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSPredicate *predicate = [[NSPredicate alloc]init];
//    if([isSynchoronization isEqualToString:@"0"])  // if net is not working
//    {
        if(noteID.length > 0)
        {
            predicate =[NSPredicate predicateWithFormat:@"userID = %@ AND noteCreateID = %@",userID,noteID];
            
        }
        else
        {
            predicate =  [NSPredicate predicateWithFormat:@"userID = %@ AND tempUserId = %@",userID,tempUserId];
        }
        
        [request setPredicate:predicate];
        NSError *error1 = nil;
        arrResult = [app.managedObjectContext executeFetchRequest:request error:&error1];
        if(arrResult.count==0 || !arrResult)
        {  // insert new record
            CreateTemporaryDelete *_objCreatNote = (CreateTemporaryDelete *)[NSEntityDescription insertNewObjectForEntityForName:@"CreateTemporaryDelete" inManagedObjectContext:manageObjectContext];
            if(_objCreatNote)
            {
                _objCreatNote.userID = userID;
                _objCreatNote.noteCreateID = noteID;
                _objCreatNote.isdeleted = [NSNumber numberWithInt:[isDeleted intValue]];
                _objCreatNote.isSynchoronization = [NSNumber numberWithInt:[isSynchoronization intValue]];
                _objCreatNote.tempUserId = tempUserId;
                _objCreatNote.noteName = noteName;
                
                
                _objCreatNote.noteCreateDate = noteCreateDate;
                _objCreatNote.timestamp = timeStamp;
                _objCreatNote.fileData = fileData;
                
            }
        }
        else
        {
            // update a record
            CreateTemporaryDelete *_objUpdateNote = (CreateTemporaryDelete *)[arrResult lastObject];
            if(_objUpdateNote)
            {
                _objUpdateNote.isdeleted = [NSNumber numberWithInt:[isDeleted intValue]];
                _objUpdateNote.isSynchoronization = [NSNumber numberWithInt:[isSynchoronization intValue]];
                _objUpdateNote.noteName = noteName;
                
                
                _objUpdateNote.noteCreateDate = noteCreateDate;
                _objUpdateNote.timestamp = timeStamp;
                _objUpdateNote.fileData = fileData;
             
                
            }
            
        }
        NSError * err = nil;
        [manageObjectContext save:&err];
        
    }
    
//    else
//    {
//        CreateTemporaryDelete *_objUpdateNote = (CreateTemporaryDelete *)[arrResult lastObject];
//        _objUpdateNote.noteCreateID = noteID;
//        NSError * err = nil;
//        [manageObjectContext save:&err];
//    }
//}

// update crete writecontex note.
+(void)oflineCreateWriteContextUpdateWithUserID:userID noteCreateID:noteCreateID noteCreateDate:(NSString *)noteCreateDate fileData:(NSString *)fileData timeStamp:(NSString *)timeStamp IsDelete:(NSString *)IsDelete noteName:(NSString *)noteName tempUserId:tempUserId
{
    NSArray * arrResult = nil;
    AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CreateNoteContentOffline" inManagedObjectContext:manageObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSPredicate *predicate =[[NSPredicate alloc]init];
    [request setEntity:entity];
    // chnage 2-1-2016
    if([noteCreateID length ] == 0)
    {
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND tempUserId = %@",userID,tempUserId];
    }
    else
    {
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND noteCreateID = %@",userID,noteCreateID];
        
    }
    [request setPredicate:predicate];
    
    NSError *error1 = nil;
    arrResult = [app.managedObjectContext executeFetchRequest:request error:&error1];
    if(arrResult.count == 0 || !arrResult)
    {
    }
    else
    {
        CreateNoteContentOffline *_objCrtNote = (CreateNoteContentOffline *)[arrResult lastObject];
        
        if(_objCrtNote)
        {
            // _objCrtNote.is = [NSNumber numberWithInt:[IsDelete intValue]];
            _objCrtNote.noteName = noteName;
            _objCrtNote.isdeleted = [NSNumber numberWithInt:[IsDelete intValue]];
            _objCrtNote.content = fileData;
            _objCrtNote.noteCreateDate = noteCreateDate;
            _objCrtNote.timestamp = timeStamp;
            
           // _objCrtNote.isSynchoronization = [NSNumber numberWithInt:0];
            
            
        }
    }
    NSError * err = nil;
    [manageObjectContext save:&err];
    
}


#pragma mark- Restore note ofline
+(void)oflineRestoreNoteWithUserID:(NSString *)userID tempUserId:(NSString *)tempUserId noteID:(NSString *)noteID isDeleted:(NSString *)isDeleted  noteCreateDate:(NSString *)noteCreateDate fileData:(NSString *)fileData timeStamp:(NSString *)timeStamp noteName:(NSString *)noteName isSynchoronization:(NSString *)isSynchoronization
{
    NSArray *arrResult= nil;
    AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CreateRestoreOfline" inManagedObjectContext:manageObjectContext];
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSPredicate *predicate = [[NSPredicate alloc]init];
    if(noteID.length > 0)
    {
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND noteCreateID = %@",userID,noteID];
        
    }
    else
    {
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND tempUserId = %@",userID,tempUserId];
    }
    
    [request setPredicate:predicate];
    NSError *error1 = nil;
    arrResult = [app.managedObjectContext executeFetchRequest:request error:&error1];
    if(arrResult.count == 0 || !arrResult)
    {
        CreateRestoreOfline *_objRestoreNote = (CreateRestoreOfline *)[NSEntityDescription insertNewObjectForEntityForName:@"CreateRestoreOfline" inManagedObjectContext:manageObjectContext];
        if(_objRestoreNote)
        {
            _objRestoreNote.userID = userID;
            _objRestoreNote.noteCreateID = noteID;
            _objRestoreNote.isdeleted = [NSNumber numberWithInt:[isDeleted intValue]];
            _objRestoreNote.noteName = noteName;
            _objRestoreNote.tempUserId = tempUserId;
            _objRestoreNote.fileData = fileData;
            _objRestoreNote.timestamp = timeStamp;
            _objRestoreNote.noteCreateDate = noteCreateDate;
            
            _objRestoreNote.isSynchoronization = [NSNumber numberWithInt:[isSynchoronization intValue]];
        }
    }
    else
    {
        CreateRestoreOfline *_objRestoreNote = [arrResult lastObject];
        
        _objRestoreNote.userID = userID;
        _objRestoreNote.noteCreateID = noteID;
        _objRestoreNote.isdeleted = [NSNumber numberWithInt:[isDeleted intValue]];
        _objRestoreNote.noteName = noteName;
        _objRestoreNote.tempUserId = tempUserId;
        _objRestoreNote.fileData = fileData;
        _objRestoreNote.timestamp = timeStamp;
        _objRestoreNote.noteCreateDate = noteCreateDate;
      //  _objRestoreNote.isdeleted = [NSNumber numberWithInt:[isDeleted intValue]];
        
        }
    NSError * err = nil;
    [manageObjectContext save:&err];
}
#pragma mark- ofline table insert or Delete Permanent in create table
+(void)oflineInsertDeletedPermanentDeleteWithUserID:(NSString *)userID tempUserId:(NSString *)tempUserId noteID:(NSString *)noteID noteCreateDate:(NSString *)noteCreateDate fileData:(NSString *)fileData timeStamp:(NSString *)timeStamp  isDeleted:(NSString *)isDeleted noteName:(NSString *)noteName isSynchoronization:(NSString *)isSynchoronization
{
    NSArray * arrResult;
    AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CreatePermanentDelete" inManagedObjectContext:manageObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSPredicate *predicate = [[NSPredicate alloc]init];
    if(noteID.length > 0)
    {
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND noteCreateID = %@",userID,noteID];
        
    }
    else
    {
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND tempUserId = %@",userID,tempUserId];
        
    }
    
    [request setPredicate:predicate];
    NSError *error1 = nil;
    arrResult = [app.managedObjectContext executeFetchRequest:request error:&error1];
    if(arrResult.count == 0 || !arrResult)
    {
        CreatePermanentDelete *_objPertDelNote = (CreatePermanentDelete *)[NSEntityDescription insertNewObjectForEntityForName:@"CreatePermanentDelete" inManagedObjectContext:manageObjectContext];
        if(_objPertDelNote)
        {
            _objPertDelNote.userID = userID;
            _objPertDelNote.noteCreateID = noteID;
            _objPertDelNote.isdeleted = [NSNumber numberWithInt:[isDeleted intValue]];
            _objPertDelNote.tempUserId = tempUserId;
            _objPertDelNote.isSynchoronization = [NSNumber numberWithInt:[isSynchoronization intValue]];
            _objPertDelNote.noteName = noteName;
            _objPertDelNote.noteCreateDate = noteCreateDate;
            _objPertDelNote.fileData = fileData;
            _objPertDelNote.timestamp = timeStamp;
        }
        
        NSError * err = nil;
        [manageObjectContext save:&err];
    }
    else
    {
        // update
        CreatePermanentDelete *_objPertDelNote = [arrResult lastObject];
        if(_objPertDelNote)
        {
            _objPertDelNote.userID = userID;
            _objPertDelNote.noteCreateID = noteID;
            _objPertDelNote.isdeleted = [NSNumber numberWithInt:[isDeleted intValue]];
            _objPertDelNote.noteName = noteName;
            _objPertDelNote.noteCreateDate = noteCreateDate;
            _objPertDelNote.fileData = fileData;
            _objPertDelNote.timestamp = timeStamp;
            NSError * err = nil;
            [manageObjectContext save:&err];
            
        }
        // update
    }
}
#pragma mark- flash out Queary
#pragma mark- Flash Out Offile table create
+(void)flashOutCreateTemporaryDeleteTableWithUserID:(NSString *)userID noteID:(NSString *)noteID tempUserId:(NSString *)tempUserId
{
    NSLog(@"%@",noteID);
    NSArray * arrResult = nil;
    AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CreateTemporaryDelete" inManagedObjectContext:manageObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSPredicate *predicate = [[NSPredicate alloc]init];
    if(noteID .length > 0)
    {
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND noteCreateID = %@",userID,noteID];
    }
    else
    {
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND tempUserId = %@",userID,tempUserId];
    }
    
    [request setPredicate:predicate];
    NSError *error1 = nil;
    arrResult = [app.managedObjectContext executeFetchRequest:request error:&error1];
    for(NSManagedObject *delete in arrResult)
    {
        [app.managedObjectContext deleteObject:delete];
    }
    [app.managedObjectContext save:&error1];
}


#pragma mark- Flash Out Offile table CreateRestore
+(void)flashOutCreateRestoreTableWithUserID:(NSString *)userID noteID:(NSString *)noteID tempUserId:(NSString *)tempUserId
{
    
    NSLog(@"%@",noteID);
    NSArray * arrResult = nil;
    AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CreateRestoreOfline" inManagedObjectContext:manageObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSPredicate *predicate = [[NSPredicate alloc]init];
    if(noteID .length > 0)
    {
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND noteCreateID = %@",userID,noteID];
    }
    else
    {
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND tempUserId = %@",userID,tempUserId];
    }
    
    [request setPredicate:predicate];
    NSError *error1 = nil;
    arrResult = [app.managedObjectContext executeFetchRequest:request error:&error1];
    for(NSManagedObject *delete in arrResult)
    {
        [app.managedObjectContext deleteObject:delete];
    }
    [app.managedObjectContext save:&error1];

}


#pragma mark-  FlashOut Restorenote
+(void)flashOutCreateRestorenoteOflineTablewithUserID:(NSString *)userID noteID:(NSString *)noteID tempUserId:(NSString *)tempUserId
{
    NSLog(@"%@",noteID);
    NSArray * arrResult = nil;
    AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CreateRestoreOfline" inManagedObjectContext:manageObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSPredicate *predicate = [[NSPredicate alloc]init];
    if(noteID .length > 0)
    {
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND noteCreateID = %@",userID,noteID];
    }
    else
    {
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND tempUserId = %@",userID,tempUserId];
    }
    
    [request setPredicate:predicate];
    NSError *error1 = nil;
    arrResult = [app.managedObjectContext executeFetchRequest:request error:&error1];
    for(NSManagedObject *delete in arrResult)
    {
        [app.managedObjectContext deleteObject:delete];
    }
    [app.managedObjectContext save:&error1];
}
#pragma mark- Flash Out CreateNoteContentOffline
+(void)flashOutCreateNoteContentOfflineTableWithUserID:(NSString *)userID noteID:(NSString *)noteID tempUserId:(NSString *)tempUserId
{
    NSLog(@"%@",noteID);
    NSArray * arrResult = nil;
    AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CreateNoteContentOffline" inManagedObjectContext:manageObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSPredicate *predicate = [[NSPredicate alloc]init];
    if(noteID .length > 0)
    {
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND noteCreateID = %@",userID,noteID];
    }
    else
    {
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND tempUserId = %@",userID,tempUserId];
    }
    
    [request setPredicate:predicate];
    NSError *error1 = nil;
    arrResult = [app.managedObjectContext executeFetchRequest:request error:&error1];
    for(NSManagedObject *delete in arrResult)
    {
        [app.managedObjectContext deleteObject:delete];
    }
    [app.managedObjectContext save:&error1];
}
#pragma mark-Flash Out CreateNote Offline

+(void)flashOutCreateNoteOflinetOfflineTableWithUserID:(NSString *)userID noteID:(NSString *)noteID tempUserId:(NSString *)tempUserId
{
    NSLog(@"%@",noteID);
    NSArray * arrResult = nil;
    AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CreateNoteOfline" inManagedObjectContext:manageObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSPredicate *predicate = [[NSPredicate alloc]init];
    if(noteID .length > 0)
    {
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND noteCreateID = %@",userID,noteID];
    }
    else
    {
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND tempUserID = %@",userID,tempUserId];
    }
    
    [request setPredicate:predicate];
    NSError *error1 = nil;
    arrResult = [app.managedObjectContext executeFetchRequest:request error:&error1];
    for(NSManagedObject *delete in arrResult)
    {
        [app.managedObjectContext deleteObject:delete];
    }
    [app.managedObjectContext save:&error1];
}
//*******************************************************************  End Ofline table Working ***********************************************


//*******************************************************************  Start backGround Synchronize ************************************************
+(NSMutableArray *)CNdBFetchBackSyncCreateNoteOfline:(NSString *)userID entityName:(NSString *)entityName
{
    NSArray *arrNote = nil;
    NSMutableArray *arrResult = [[NSMutableArray alloc]init];
    AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:manageObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID = %@",userID];
    [request setPredicate:predicate];
    NSError *error1 = nil;
    arrNote = [app.managedObjectContext executeFetchRequest:request error:&error1];
    if(arrNote.count == 0 || !arrNote)
    {
        return arrResult;
    }
    else
    {
        [arrResult addObjectsFromArray:arrNote];
        
    }
    return arrResult;
}

#pragma update noteID with tempuser ID

+(void)CNdBreplaceTempUserIdWithNoteId:(NSString *)userID tempNoteid:(NSString *)tempNoteid noteID:(NSString *)noteID tableName:(NSString* )tableName
{
    AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:manageObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND tempUserId = %@",userID,tempNoteid];
    [request setPredicate:predicate];
    NSError *error1 = nil;
    NSArray *items = [app.managedObjectContext executeFetchRequest:request error:&error1];
    if(items.count > 0)
    {
        if([tableName isEqualToString:@"CreateNoteContentOffline"])
        {
            CreateNoteContentOffline * _objClass = [items lastObject];
           // _objClass.tempUserId = @"";
            _objClass.noteCreateID = noteID;
            NSError * err = nil;
            [manageObjectContext save:&err];
        }
        else if([tableName isEqualToString:@"CreateRestoreOfline"])
        {
            CreateRestoreOfline * _objClass = [items lastObject];
           // _objClass.tempUserId = @"";
            _objClass.noteCreateID = noteID;
            NSError * err = nil;
            [manageObjectContext save:&err];
        }
        else if([tableName isEqualToString:@"CreateTemporaryDelete"])
        {
            CreateTemporaryDelete * _objClass = [items lastObject];
            //_objClass.tempUserId = @"";
            _objClass.noteCreateID = noteID;
            NSError * err = nil;
            [manageObjectContext save:&err];
        }
    }
    else
    {
    }
}
// new chnage
#pragma background update sync
+(void)CNdBUpdateMasterTableBackgroundSync:(NSString *)userID noteID:(NSString *)noteID noteName:(NSString *)noteName isDeleted:(NSString *)isDeleted isSynchoronization:(NSString *) isSynchoronization fileData:(NSString *)fileData dateTime:(NSString *)dateTime tempUserId:(NSString *)tempUserId keyUpdate:(NSString *)keyUpdate
{
 
    
    if([keyUpdate isEqualToString:@"master"])
    {
        NSArray * arrResult = nil;
        AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"MasterNote" inManagedObjectContext:manageObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        [request setEntity:entity];
        NSPredicate *predicate =[[NSPredicate alloc]init];
//        if(noteID .length > 0)
//        {
//            predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND noteCreateID = %@",userID,noteID];
//        }
        
            predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND tempUserId = %@",userID,tempUserId];
        

        [request setPredicate:predicate];
        NSError *error1 = nil;
        arrResult = [app.managedObjectContext executeFetchRequest:request error:&error1];
        if(arrResult.count == 0 || !arrResult)
        {
        }
        else
        {
            // simple update
            MasterNote *objNote = (MasterNote *)[arrResult lastObject];
            objNote.noteCreateID = noteID ;
            objNote.isdeleted = [NSNumber numberWithInt:[isDeleted intValue]];
            if([noteName length]==0)
            {
                  objNote.noteName = objNote.noteName;
            }
            else
            {
            objNote.noteName = noteName;
            }
            objNote.fileData = fileData;
            objNote.noteCreateDate = dateTime;
            //chnage 4-2-2016
            objNote.timestamp = dateTime;
            //end
            //objNote.tempUserId = @"";
             objNote.tempUserId = tempUserId;
            objNote.isSynchoronization = [NSNumber numberWithInt:[isSynchoronization intValue]];
            NSError * err = nil;
            [manageObjectContext save:&err];
        }
    }
    else if([keyUpdate isEqualToString:@"trash"])
    {
        
        NSArray * arrResult = nil;
        AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"MasterNote" inManagedObjectContext:manageObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        [request setEntity:entity];
        NSPredicate *predicate =[[NSPredicate alloc]init];
        if(noteID .length > 0)
        {
            predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND noteCreateID = %@",userID,noteID];
        }
        else
        {
            predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND tempUserId = %@",userID,tempUserId];
        }
        [request setPredicate:predicate];
        NSError *error1 = nil;
        arrResult = [app.managedObjectContext executeFetchRequest:request error:&error1];
        if(arrResult.count == 0 || !arrResult)
        {
        }
        else
        {
            // simple update
            MasterNote *objNote = (MasterNote *)[arrResult lastObject];
            objNote.noteCreateID = noteID ;
            objNote.isdeleted = [NSNumber numberWithInt:[isDeleted intValue]];
            if([noteName length]==0)
            {
                objNote.noteName = objNote.noteName;
            }
            else
            {
                objNote.noteName = noteName;
            }
           // objNote.noteName = noteName;
            objNote.isSynchoronization = [NSNumber numberWithInt:[isSynchoronization intValue]];
            NSError * err = nil;
            [manageObjectContext save:&err];
        }
    }
    else if([keyUpdate isEqualToString:@"delete"])
    {
        NSArray * arrResult = nil;
        AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"MasterNote" inManagedObjectContext:manageObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        [request setEntity:entity];
        NSPredicate *predicate =[[NSPredicate alloc]init];
        if(noteID .length > 0)
        {
            predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND noteCreateID = %@",userID,noteID];
        }
        else
        {
            predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND tempUserId = %@",userID,tempUserId];
        }

        [request setPredicate:predicate];
        NSError *error1 = nil;
        arrResult = [app.managedObjectContext executeFetchRequest:request error:&error1];
        if(arrResult.count == 0 || !arrResult)
        {
        }
        else
        {
            // simple update
            MasterNote *objNote = (MasterNote *)[arrResult lastObject];
            objNote.noteCreateID = noteID ;
            if([noteName length]==0)
            {
                objNote.noteName = objNote.noteName;
            }
            else
            {
                objNote.noteName = noteName;
            }
          //  objNote.noteName = noteName;
            objNote.isSynchoronization = [NSNumber numberWithInt:[isSynchoronization intValue]];
            NSError * err = nil;
            [manageObjectContext save:&err];
        }
        
    }
    else if([keyUpdate isEqualToString:@"contantUpdate"])
    {
        NSArray * arrResult = nil;
        AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"MasterNote" inManagedObjectContext:manageObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        [request setEntity:entity];
        NSPredicate *predicate =[[NSPredicate alloc]init];
        if(noteID .length > 0)
        {
            predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND noteCreateID = %@",userID,noteID];
        }
        else
        {
            predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND tempUserId = %@",userID,tempUserId];
        }
       
        [request setPredicate:predicate];
        NSError *error1 = nil;
        arrResult = [app.managedObjectContext executeFetchRequest:request error:&error1];
        if(arrResult.count == 0 || !arrResult)
        {
        }
        else
        {
            // simple update
            MasterNote *objNote = (MasterNote *)[arrResult lastObject];
            objNote.noteCreateID = noteID ;
            if([noteName length]==0)
            {
                objNote.noteName = objNote.noteName;
            }
            else
            {
                objNote.noteName = noteName;
            }
         //   objNote.noteName = noteName;
            objNote.fileData = fileData;
            objNote.noteCreateDate = dateTime;
            //chnage 4-2-2016
            objNote.timestamp = dateTime;
            //end
            objNote.isSynchoronization = [NSNumber numberWithInt:[isSynchoronization intValue]];
            NSError * err = nil;
            [manageObjectContext save:&err];
        }
        
        
    }
    
    else if([keyUpdate isEqualToString:@"masterCreateNoteUpdate"])
    {
        
        NSArray * arrResult = nil;
        AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"MasterNote" inManagedObjectContext:manageObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        [request setEntity:entity];
        NSPredicate *predicate =[[NSPredicate alloc]init];
        
        
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND tempUserId = %@",userID,tempUserId];
        
        
        [request setPredicate:predicate];
        NSError *error1 = nil;
        arrResult = [app.managedObjectContext executeFetchRequest:request error:&error1];
        if(arrResult.count == 0 || !arrResult)
        {
        }
        else
        {
            // simple update
            MasterNote *objNote = (MasterNote *)[arrResult lastObject];
            objNote.noteCreateID = noteID ;
            objNote.isdeleted = [NSNumber numberWithInt:[isDeleted intValue]];
            if([noteName length]==0)
            {
            objNote.noteName = objNote.noteName;
            }
            else
            {
                objNote.noteName = noteName;
            }
            objNote.fileData = fileData;
            objNote.noteCreateDate = dateTime;
            objNote.timestamp = dateTime;
            objNote.tempUserId = tempUserId;
            objNote.userID = userID;
            objNote.isSynchoronization = [NSNumber numberWithInt:[isSynchoronization intValue]];
            NSError * err = nil;
            [manageObjectContext save:&err];
        }
        
    }

    
}


#pragma mark -
#pragma mar New code implemented


// Local Crete a note
+(void)localCreateNewNotewithUserID:(NSString *)userID noteCreateID:(NSString *)noteCreateID noteTitle:(NSString *)noteTitle isDeleted:(NSString *)isDeleted content:(NSString *)content noteCreateDate:(NSString *)noteCreateDate isSynchoronization:(NSString *)isSynchoronization tempNoteID:(NSString *)tempNoteID
{
    
    AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
    MasterNote *_objMasterTable = (MasterNote *)[NSEntityDescription insertNewObjectForEntityForName:@"MasterNote" inManagedObjectContext:manageObjectContext];
    _objMasterTable.userID = userID;
    _objMasterTable.noteCreateID = noteCreateID;
    _objMasterTable.noteCreateDate = noteCreateDate;
    _objMasterTable.isdeleted = [NSNumber numberWithInt:[isDeleted intValue]];
    _objMasterTable.noteName = noteTitle;
    _objMasterTable.tempUserId = tempNoteID;
    _objMasterTable.fileData = content;
    _objMasterTable.isSynchoronization = [NSNumber numberWithInt:[isSynchoronization intValue]];
    
    _objMasterTable.timestamp = noteCreateDate;
    
    
    NSError * err = nil;
    [manageObjectContext save:&err];
    
    
}


// Replace ID
#pragma background update sync
+(void)LocalDataBaseUpdateInBackgroundSync:(NSString *)userID noteID:(NSString *)noteID noteName:(NSString *)noteName isDeleted:(NSString *)isDeleted isSynchoronization:(NSString *) isSynchoronization fileData:(NSString *)fileData dateTime:(NSString *)dateTime tempUserId:(NSString *)tempUserId keyUpdate:(NSString *)keyUpdate
{
 
    if([keyUpdate isEqualToString:@"master"])
    {
        NSArray * arrResult = nil;
        AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"MasterNote" inManagedObjectContext:manageObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        [request setEntity:entity];
        NSPredicate *predicate =[[NSPredicate alloc]init];
        
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND tempUserId = %@",userID,tempUserId];
        
        
        [request setPredicate:predicate];
        NSError *error1 = nil;
        arrResult = [app.managedObjectContext executeFetchRequest:request error:&error1];
        if(arrResult.count == 0 || !arrResult)
        {
        }
        else
        {
            // simple update
            MasterNote *objNote = (MasterNote *)[arrResult lastObject];
            objNote.noteCreateID = noteID ;
            objNote.isdeleted = [NSNumber numberWithInt:[isDeleted intValue]];
            objNote.fileData = fileData;
            objNote.noteCreateDate = dateTime;
            //chnage 4-2-2016
            objNote.timestamp = dateTime;
            //end
            objNote.tempUserId = tempUserId;
            objNote.isSynchoronization = [NSNumber numberWithInt:[isSynchoronization intValue]];
            NSError * err = nil;
            [manageObjectContext save:&err];
        }
    }
}
// move to trash
+(void)localMoveToTrashWithUserID:(NSString *)userID noteCreateID:(NSString *)noteCreateID isDeleted:(NSString *)isDeleted noteName:(NSString *)noteName tempUserId:(NSString *)tempUserId noteCreateDate:(NSString *)noteCreateDate isSynchoronization:(NSString *)isSynchoronization
{
    NSArray * arrResult = nil;
    NSPredicate *predicate = [[NSPredicate alloc]init];
       NSString *timeStamp;
    AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MasterNote" inManagedObjectContext:manageObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    [request setPredicate:predicate];
    
    
    if(noteCreateID.length > 0)
    {
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND noteCreateID = %@",userID,noteCreateID];
        
    }
    else
    {
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND tempUserId = %@",userID,tempUserId];
        
    }
    
    // chnage 29-2-2016 exceptions
      if(tempUserId.length == 0)
     {
          predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND noteCreateDate = %@",userID,noteCreateDate];
          tempUserId = [[CNHelper sharedInstance]gettimestampStringFroLocalTime];
         
     }
    [request setPredicate:predicate];
    NSError *error1 = nil;
    
    arrResult = [app.managedObjectContext executeFetchRequest:request error:&error1];
    if(arrResult.count == 0 || !arrResult)
    {
    }
    // uodate
    
        else
        {
            
            NSError * err = nil;
            MasterNote *objNote = (MasterNote *)[arrResult lastObject];
            objNote.isdeleted = [NSNumber numberWithInt:[isDeleted intValue]];
            objNote.noteName = noteName;
            objNote.isSynchoronization = [NSNumber numberWithInt:[isSynchoronization intValue]];
         
            // chnage 29-2-2016
            objNote.tempUserId = tempUserId;
            
        [manageObjectContext save:&err];

            
        }
        
}





// move to delte parmantly
+(void)localPermanentlyDeleteWithUserID:(NSString *)userID noteCreateID:(NSString *)noteCreateID isDeleted:(NSString *)isDeleted noteName:(NSString *)noteName tempUserId:(NSString *)tempUserId noteCreateDate:(NSString *)noteCreateDate isSynchoronization:(NSString *)isSynchoronization
{
    NSArray * arrResult = nil;
    NSPredicate *predicate = [[NSPredicate alloc]init];
    
    AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MasterNote" inManagedObjectContext:manageObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    [request setPredicate:predicate];
    
    
    if(noteCreateID.length > 0)
    {
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND noteCreateID = %@",userID,noteCreateID];
        
    }
    else
    {
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND tempUserId = %@",userID,tempUserId];
        
    }
    
    // chnage 29-2-2016 exceptions
    if(tempUserId.length == 0)
    {
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND noteCreateDate = %@",userID,noteCreateDate];
        tempUserId = [[CNHelper sharedInstance]gettimestampStringFroLocalTime];
        
    }
    
    
    
    [request setPredicate:predicate];
    NSError *error1 = nil;
    
    arrResult = [app.managedObjectContext executeFetchRequest:request error:&error1];
    if(arrResult.count == 0 || !arrResult)
    {
    }
    else
    {
        if([isSynchoronization isEqualToString:@"0"]) // net is not working
        {
            NSError * err = nil;
            MasterNote *objNote = (MasterNote *)[arrResult lastObject];
            objNote.isdeleted = [NSNumber numberWithInt:[isDeleted intValue]];
            
            // chnage 29-2-2016
            objNote.tempUserId = tempUserId;
            
            objNote.isSynchoronization = [NSNumber numberWithInt:[isSynchoronization intValue]];
            [manageObjectContext save:&err];
            
            
        }
        else
        {
        
        
    NSError *error1 = nil;
    for(NSManagedObject *delete in arrResult)
    {
        [app.managedObjectContext deleteObject:delete];
    }
    [app.managedObjectContext save:&error1];
        
    }
    }
}

// restore

+(void)localRestoreNoteWithUserID:(NSString *)userID noteCreateID:(NSString *)noteCreateID isDeleted:(NSString *)isDeleted noteName:(NSString *)noteName tempUserId:(NSString *)tempUserId noteCreateDate:(NSString *)noteCreateDate isSynchoronization:(NSString *)isSynchoronization
{


    NSArray * arrResult = nil;
    NSPredicate *predicate = [[NSPredicate alloc]init];
       NSString *timeStamp;
    AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MasterNote" inManagedObjectContext:manageObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    [request setPredicate:predicate];
    
    
    if(noteCreateID.length > 0)
    {
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND noteCreateID = %@",userID,noteCreateID];
        
    }
    else
    {
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND tempUserId = %@",userID,tempUserId];
        
    }
    
    // chnage 29-2-2016 exceptions
    if(tempUserId.length == 0)
    {
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND noteCreateDate = %@",userID,noteCreateDate];
        tempUserId = [[CNHelper sharedInstance]gettimestampStringFroLocalTime];
        
    }
    [request setPredicate:predicate];
    NSError *error1 = nil;
    
    arrResult = [app.managedObjectContext executeFetchRequest:request error:&error1];
    if(arrResult.count == 0 || !arrResult)
    {
    }

    
    // uodate
    
        else
        { NSError * err = nil;
            MasterNote *objNote = (MasterNote *)[arrResult lastObject];
            objNote.isdeleted = [NSNumber numberWithInt:[isDeleted intValue]];
            objNote.isSynchoronization = [NSNumber numberWithInt:[isSynchoronization intValue]];
        // chnage 29-2-2016
           
            objNote.tempUserId = tempUserId;
            [manageObjectContext save:&err];
        }

        
        
}
// delete all at a time.
+(void)localEmptyALLPermanentlyDeleteWithUserID:(NSString *)userID noteCreateID:(NSString *)noteCreateID isDeleted:(NSString *)isDeleted noteName:(NSString *)noteName tempUserId:(NSString *)tempUserId isSynchoronization:(NSString *)isSynchoronization
{
    NSArray * arrResult = nil;
    NSPredicate *predicate = [[NSPredicate alloc]init];
    
    AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MasterNote" inManagedObjectContext:manageObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    [request setPredicate:predicate];
    
    
    if(noteCreateID.length > 0)
    {
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND noteCreateID = %@",userID,noteCreateID];
        
    }
    else
    {
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND tempUserId = %@",userID,tempUserId];
        
    }
    [request setPredicate:predicate];
    NSError *error1 = nil;
    
    arrResult = [app.managedObjectContext executeFetchRequest:request error:&error1];
    if(arrResult.count == 0 || !arrResult)
    {
    }
    else
    {
        if([isSynchoronization isEqualToString:@"0"]) // net is not working
        {
            NSError * err = nil;
            MasterNote *objNote = (MasterNote *)[arrResult lastObject];
            objNote.isdeleted = [NSNumber numberWithInt:[isDeleted intValue]];
            
            objNote.isSynchoronization = [NSNumber numberWithInt:[isSynchoronization intValue]];
            [manageObjectContext save:&err];
            
            
        }
      
    }
}

+(void)localFlashOutAllRecordsMasterNote:(NSString*)tableName userID:(NSString *)userID
{
    AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:manageObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND isdeleted = %@",userID,@"-1"];
    [request setPredicate:predicate];
    NSError *error1 = nil;
    NSArray *items = [app.managedObjectContext executeFetchRequest:request error:&error1];
    for (NSManagedObject *obj in items)
    {
        [app.managedObjectContext deleteObject:obj];
    }
    NSError *error = nil;
    [app.managedObjectContext save:&error];
}

// update note name with description
+(void)localWrtingAndEditNoteUpdateWithUserId:(NSString *)userID noteCreateID:(NSString *)noteCreateID tempUserId:(NSString *)tempUserId content:(NSString *)content noteName:(NSString *)noteName updateNoteDateTime:(NSString *)updateNoteDateTime isSynchoronization:(NSString *)isSynchoronization
{
    NSArray * arrResult = nil;
    NSPredicate *predicate = [[NSPredicate alloc]init];
    
    AppDelegate* app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* manageObjectContext=app.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MasterNote" inManagedObjectContext:manageObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    [request setPredicate:predicate];
    
    
    if(noteCreateID.length > 0)
    {
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND noteCreateID = %@",userID,noteCreateID];
        
    }
    else
    {
        predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND tempUserId = %@",userID,tempUserId];
        
    }
    [request setPredicate:predicate];
    NSError *error1 = nil;
    
    arrResult = [app.managedObjectContext executeFetchRequest:request error:&error1];
    if(arrResult.count == 0 || !arrResult)
    {
    }
else
{
    // update
    MasterNote *_objNote = (MasterNote *)[arrResult lastObject];
    _objNote.noteCreateID = noteCreateID ;
    _objNote.fileData = content;
    _objNote.noteName = noteName;
    _objNote.isSynchoronization = [NSNumber numberWithInt:[isSynchoronization intValue]];
    _objNote.noteCreateDate = updateNoteDateTime;
    _objNote.timestamp = updateNoteDateTime;
    NSError * err = nil;
    [manageObjectContext save:&err];
    }

    
}


//*******************************************************************  End backGround Synchronize ***************************************************
@end
