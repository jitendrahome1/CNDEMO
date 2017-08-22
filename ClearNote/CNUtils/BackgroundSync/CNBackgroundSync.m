//
//  CNBackgroundSync.m
//  ClearNote
//
//  Created by Jitendra Agarwal on 02/12/15.
//  Copyright © 2015 Jitendra Agarwal. All rights reserved.
//

#import "CNBackgroundSync.h"

@implementation CNBackgroundSync
AppDelegate *app;
+(CNBackgroundSync *)sharedInstance
{
    static CNBackgroundSync *sharedInstance_ = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedInstance_ = [[CNBackgroundSync alloc] init];
        app=[[UIApplication sharedApplication]delegate];
    });
    
    return sharedInstance_;
}
-(void)StartProcess:(id)Message
{
    dispatch_async([CNHelper sharedInstance].backgroundQueue, ^{
        
        NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(Background_API_Call:) object:Message];
        if ([CNHelper sharedInstance].queue.operationCount > 0) {
            [op addDependency:[[CNHelper sharedInstance].queue.operations lastObject]];
        }
        [self performSelectorOnMainThread:@selector(callQueueWithInterval:) withObject:op waitUntilDone:YES];
    });
}

-(void)callQueueWithInterval:(NSInvocationOperation *)_operation
{
    if([CNHelper sharedInstance].queueCount>1)
        [[CNHelper sharedInstance] performSelector:@selector(insertIntoQueue:) withObject:_operation afterDelay:ADD_QUEUE_INTERVAL*[CNHelper sharedInstance].queueCount];
    else
        [[CNHelper sharedInstance] insertIntoQueue:_operation];
    
    [CNHelper sharedInstance].queueCount ++;
}
-(void)Background_API_Call:(id)_Message
{
    if ([_Message isKindOfClass: [CreateNoteOfline class]]) {
        CreateNoteOfline * _uploadedData = (CreateNoteOfline*)_Message;
        [self postDataforRequestId:Request_Create_New_Note entityName:_uploadedData];
    }
    else if ([_Message isKindOfClass: [CreateTemporaryDelete class]]) {
        CreateTemporaryDelete * _uploadedData = (CreateTemporaryDelete*)_Message;
        [self postDataforRequestId:Request_Move_Trash_Note entityName:_uploadedData];
    }
    else if ([_Message isKindOfClass: [CreatePermanentDelete class]]) {
        CreatePermanentDelete * _uploadedData = (CreatePermanentDelete*)_Message;
        [self postDataforRequestId:Request_Delete_Note entityName:_uploadedData];
    }
    else if ([_Message isKindOfClass: [CreateRestoreOfline class]]) {
        CreateRestoreOfline * _uploadedData = (CreateRestoreOfline*)_Message;
        [self postDataforRequestId:Request_Restore_Note entityName:_uploadedData];
    }
    else if ([_Message isKindOfClass: [CreateNoteContentOffline class]]) {
        CreateNoteContentOffline * _uploadedData = (CreateNoteContentOffline*)_Message;
        [self postDataforRequestId:Request_Update_Note_Contant entityName:_uploadedData];
    }
    
}
#pragma mark- post and get data API call
-(void)postDataforRequestId:(int) requestId entityName:(id)entityName
{   NSMutableArray * arrFetchData ;
    arrFetchData = [[NSMutableArray alloc]init];
    CreateNoteOfline *_objCrtNewNote;
    if(requestId == Request_Create_New_Note && [entityName isKindOfClass:[CreateNoteOfline class]])
    {
        // CreateNoteOfline *_objCrtNewNote = (CreateNoteOfline *)entityName;
        
        [arrFetchData removeAllObjects];
        arrFetchData = [CNDataHelper CNdBFetchBackSyncCreateNoteOfline:get_ValueByKye(kLoginID) entityName:@"CreateNoteOfline"];
        for(int i = 0; i<arrFetchData.count; i++)
        {
            _objCrtNewNote = [arrFetchData objectAtIndex:i];
            
            [[CNRequestController sharedInstance]CNRequestCreateNoteWithUserID:get_ValueByKye(kLoginID) noteTitle:_objCrtNewNote.noteName content:_objCrtNewNote.fileData createDateTime:_objCrtNewNote.timestamp isDeleted:[NSString stringWithFormat:@"%@",[_objCrtNewNote isdeleted]] isSynchronise:@"0" success:^(id responseDict) {
                if (responseDict != (id)[NSNull null])
                {
                    [self notifyRequesterWithData:responseDict forRequest:Request_Create_New_Note entityName:_objCrtNewNote];
                }
                
                NSError * error = nil;
                if (![[app managedObjectContext] save:&error])
                {
                    NSLog(@"Error ! %@", error);
                    
                    
                }
                
             [[CNHelper sharedInstance]replaceTempidWithNoteID:get_ValueByKye(kLoginID) noteID:responseDict[@"noteId"] tempUserId:_objCrtNewNote.tempUserID];
          
            }
             
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[CNAddBackgroundOparation sharedInstance] AddBackgroundProcess];
                                                                           
        [[app managedObjectContext] deleteObject:_objCrtNewNote];
            if (![[app managedObjectContext] save:&error])
            {
            NSLog(@"Error ! %@", error);
                                                                               
                                                                               
            }
                                                                           
                                                                           
        }];
   }
        

        
    }
    else if(requestId == Request_Move_Trash_Note && [entityName isKindOfClass:[CreateTemporaryDelete class]])
    {
        NSString * currentTimestamp= nil;
        currentTimestamp = [[CNHelper sharedInstance]gettimestampStringFroLocalTime];
       
        CreateTemporaryDelete *_objCrtNewNote = (CreateTemporaryDelete *)entityName;
//        
//        
//        
//        if([_objCrtNewNote.noteCreateID length]==0)
//        {
//            
//            // crete a note
//            
//            [[CNRequestController sharedInstance]CNRequestCreateNoteWithUserID:get_ValueByKye(kLoginID) noteTitle:_objCrtNewNote.noteName content:_objCrtNewNote.fileData createDateTime:_objCrtNewNote.noteCreateDate isDeleted:[NSString stringWithFormat:@"%@",_objCrtNewNote.isdeleted] isSynchronise:@"0" success:^(id responseDict) {
//                if (responseDict != (id)[NSNull null])
//                {
//                    [self notifyRequesterAgianCreteNoteWithSucess:responseDict requestId:Request_Create_New_Note entityName:_objCrtNewNote];
//                }
//            }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            
//            
//                // delte local data db
//                [[app managedObjectContext] deleteObject:_objCrtNewNote];
//               // NSError * error = nil;
//                if (![[app managedObjectContext] save:&error])
//                {
//                    NSLog(@"Error ! %@", error);
//                }
//
//            
//            
//            }];
//          
//            
//        }

            
            
            [[CNRequestController sharedInstance]CNRequestMoveToTrashWithUserID:get_ValueByKye(kLoginID) noteID:_objCrtNewNote.noteCreateID currentTimestamp:currentTimestamp success:^(id responseDict) {
                
                [self notifyRequesterWithData:responseDict forRequest:Request_Move_Trash_Note entityName:_objCrtNewNote];
                
                [[CNAddBackgroundOparation sharedInstance] AddBackgroundProcess];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               // [[CNAddBackgroundOparation sharedInstance] AddBackgroundProcess];
                
                // delte local data db
                [[app managedObjectContext] deleteObject:_objCrtNewNote];
                // NSError * error = nil;
                if (![[app managedObjectContext] save:&error])
                {
                    NSLog(@"Error ! %@", error);
                }
                

                
            }];
        
    
            // delte local data db
            [[app managedObjectContext] deleteObject:_objCrtNewNote];
            NSError * error = nil;
            if (![[app managedObjectContext] save:&error])
            {
                NSLog(@"Error ! %@", error);
            }
        
        
      }
    else if(requestId == Request_Delete_Note && [entityName isKindOfClass:[CreatePermanentDelete class]])
    {
        CreatePermanentDelete *_objCrtNewNote = (CreatePermanentDelete *)entityName;
       NSString *currentTimestamp = [[CNHelper sharedInstance]gettimestampStringFroLocalTime];
        
        
        
        if([_objCrtNewNote.noteCreateID length]==0)
        {
            
            // crete a note
            
            [[CNRequestController sharedInstance]CNRequestCreateNoteWithUserID:get_ValueByKye(kLoginID) noteTitle:_objCrtNewNote.noteName content:_objCrtNewNote.fileData createDateTime:_objCrtNewNote.noteCreateDate isDeleted:[NSString stringWithFormat:@"%@",_objCrtNewNote.isdeleted] isSynchronise:@"0" success:^(id responseDict) {
                if (responseDict != (id)[NSNull null])
                {
                    [self notifyRequesterAgianCreteNoteWithSucess:responseDict requestId:Request_Create_New_Note entityName:_objCrtNewNote];
                }
            }
             
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          
            // delte local data db
            [[app managedObjectContext] deleteObject:_objCrtNewNote];
            // NSError * error = nil;
            if (![[app managedObjectContext] save:&error])
            {
                NSLog(@"Error ! %@", error);
            }
            

            
            
        }];
            
            
    }
        else
        {
            
            
            
            [[CNRequestController sharedInstance]CNRequestDeleteNoteWithUserID:get_ValueByKye(kLoginID) noteID:_objCrtNewNote.noteCreateID currentTimestamp:currentTimestamp success:^(id responseDict) {
                
                [self notifyRequesterWithData:responseDict forRequest:Request_Delete_Note entityName:_objCrtNewNote];
                
                
                [[CNAddBackgroundOparation sharedInstance] AddBackgroundProcess];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
                //[[CNAddBackgroundOparation sharedInstance] AddBackgroundProcess];
          
                // delte local data db
                [[app managedObjectContext] deleteObject:_objCrtNewNote];
                // NSError * error = nil;
                if (![[app managedObjectContext] save:&error])
                {
                    NSLog(@"Error ! %@", error);
                }
            
            
            }];
            
            
            // delte local data db
            [[app managedObjectContext] deleteObject:_objCrtNewNote];
            NSError * error = nil;
            if (![[app managedObjectContext] save:&error])
            {
                NSLog(@"Error ! %@", error);
            }
            
        }
        
     
        [[CNAddBackgroundOparation sharedInstance] AddBackgroundProcess];
        
    }
    else if(requestId == Request_Restore_Note && [entityName isKindOfClass:[CreateRestoreOfline class]])
    {
        NSString *currentTimestamp = [[CNHelper sharedInstance]gettimestampStringFroLocalTime];
        CreateRestoreOfline *_objCrtNewNote = (CreateRestoreOfline *)entityName;
        
        
        
        if([_objCrtNewNote.noteCreateID length]==0)
        {
            
            // crete a note
            
            [[CNRequestController sharedInstance]CNRequestCreateNoteWithUserID:get_ValueByKye(kLoginID) noteTitle:_objCrtNewNote.noteName content:_objCrtNewNote.fileData createDateTime:_objCrtNewNote.noteCreateDate isDeleted:[NSString stringWithFormat:@"%@",_objCrtNewNote.isdeleted] isSynchronise:@"0" success:^(id responseDict) {
                if (responseDict != (id)[NSNull null])
                {
                    [self notifyRequesterAgianCreteNoteWithSucess:responseDict requestId:Request_Create_New_Note entityName:_objCrtNewNote];
                }
            }
             
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                           
            }];
            
            
            
        }
        
        
        else{
            
            
            [[CNRequestController sharedInstance]CNRequestRestoreNoteWithUserID:get_ValueByKye(kLoginID) noteID:_objCrtNewNote.noteCreateID currentTimestamp:currentTimestamp success:^(id responseDict) {
                [self notifyRequesterWithData:responseDict forRequest:Request_Restore_Note entityName:_objCrtNewNote];
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                //[[CNAddBackgroundOparation sharedInstance] AddBackgroundProcess];
          
                // delte local data db
                [[app managedObjectContext] deleteObject:_objCrtNewNote];
                // NSError * error = nil;
                if (![[app managedObjectContext] save:&error])
                {
                    NSLog(@"Error ! %@", error);
                }
            
            
            }];
            
            [[app managedObjectContext] deleteObject:_objCrtNewNote];
            NSError * error = nil;
            if (![[app managedObjectContext] save:&error])
            {
                NSLog(@"Error ! %@", error);
            }
            [[CNAddBackgroundOparation sharedInstance] AddBackgroundProcess];
            
            
            
        }
        
    }
    else if(requestId == Request_Update_Note_Contant && [entityName isKindOfClass:[CreateNoteContentOffline class]])
    {
        CreateNoteContentOffline *_objCrtNewNote = (CreateNoteContentOffline *)entityName;
        NSString *currentTimestamp = [[CNHelper sharedInstance]gettimestampStringFroLocalTime];
        
//        if([_objCrtNewNote.noteCreateID length]==0)
//        {
//            
//            // crete a note
//            
//            [[CNRequestController sharedInstance]CNRequestCreateNoteWithUserID:get_ValueByKye(kLoginID) noteTitle:_objCrtNewNote.noteName content:_objCrtNewNote.content createDateTime:_objCrtNewNote.noteCreateDate isDeleted:[NSString stringWithFormat:@"%@",_objCrtNewNote.isdeleted] isSynchronise:@"0" success:^(id responseDict) {
//                if (responseDict != (id)[NSNull null])
//                {
//                    [self notifyRequesterAgianCreteNoteWithSucess:responseDict requestId:Request_Create_New_Note entityName:_objCrtNewNote];
//                }
//            }
//             
//        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                                                           
//    }];
//        }
        
//        else{
        
            [[CNRequestController sharedInstance]CNRequestWriteAndEditWithUserID:get_ValueByKye(kLoginID) noteID:_objCrtNewNote.noteCreateID content:_objCrtNewNote.content noteTitle:_objCrtNewNote.noteName currentTimestamp:currentTimestamp success:^(id responseDict) {
                //end
                if (responseDict != (id)[NSNull null])
                {
                    [self notifyRequesterWithData:responseDict forRequest:Request_Update_Note_Contant entityName:_objCrtNewNote];
                    
                    
                }
                [[CNAddBackgroundOparation sharedInstance] AddBackgroundProcess];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                //[[CNAddBackgroundOparation sharedInstance] AddBackgroundProcess];
                // delte local data db
                [[app managedObjectContext] deleteObject:_objCrtNewNote];
                // NSError * error = nil;
                if (![[app managedObjectContext] save:&error])
                {
                    NSLog(@"Error ! %@", error);
                }
            
            
            }];
            
            [[app managedObjectContext] deleteObject:_objCrtNewNote];
            NSError * error = nil;
            if (![[app managedObjectContext] save:&error])
            {
                NSLog(@"Error ! %@", error);
            }
            [[CNAddBackgroundOparation sharedInstance] AddBackgroundProcess];
            
        }
        
    //}
}

-(void)notifyRequesterWithData:(id) responseData forRequest:(int) requestId entityName:(id)entityName
{
    
    if(requestId == Request_Create_New_Note && [entityName isKindOfClass:[CreateNoteOfline class]])
    {
        CreateNoteOfline *_objCrtNewNote = (CreateNoteOfline *)entityName;;
        NSLog(@"%@ note Create",responseData);
        NSString *message = nil;
        NSString *code = responseData[@"ResponseCode"];
        message = responseData[@"ResponseDetails"];
        if([code isEqualToString:@"200"])
        {
            [CNDataHelper CNdBUpdateMasterTableBackgroundSync:get_ValueByKye(kLoginID) noteID:responseData[@"noteId"] noteName:_objCrtNewNote.noteName isDeleted:responseData[@"isDeleted"] isSynchoronization:responseData[@"isSynchronise"] fileData:responseData[@"content"] dateTime:_objCrtNewNote.timestamp tempUserId:_objCrtNewNote.tempUserID keyUpdate:@"master"];
            
        }
    }
    else if(requestId == Request_Move_Trash_Note && [entityName isKindOfClass:[CreateTemporaryDelete class]])
    {
        NSString *message = nil;
        NSString *code = responseData[@"ResponseCode"];
        message = responseData[@"ResponseDetails"];
        NSLog(@" Note Move To trash %@",responseData);
        if([code isEqualToString:@"200"])
        {
            CreateTemporaryDelete *_crteObj = (CreateTemporaryDelete *)entityName;
            [CNDataHelper CNdBUpdateMasterTableBackgroundSync:get_ValueByKye(kLoginID) noteID:responseData[@"noteId"] noteName:_crteObj.noteName isDeleted:responseData[@"isDeleted"] isSynchoronization:responseData[@"isSynchronise"] fileData:@"" dateTime:@"" tempUserId:_crteObj.tempUserId keyUpdate:@"trash"];
        }
        
    }
    else if(requestId == Request_Delete_Note && [entityName isKindOfClass:[CreatePermanentDelete class]])
    {
        NSLog(@" Note Delete %@",responseData);
        
        CreatePermanentDelete *_crteObj = (CreatePermanentDelete *)entityName;
        [CNDataHelper CNdBUpdateMasterTableBackgroundSync:get_ValueByKye(kLoginID) noteID:responseData[@"noteId"] noteName:_crteObj.noteName isDeleted:@""isSynchoronization:responseData[@"isSynchronise"] fileData:@"" dateTime:@"" tempUserId:_crteObj.tempUserId keyUpdate:@"delete"];
    }
    else if(requestId == Request_Restore_Note && [entityName isKindOfClass:[CreateRestoreOfline class]])
    {
        CreateRestoreOfline *_crteObj = (CreateRestoreOfline *)entityName;
        [CNDataHelper CNdBUpdateMasterTableBackgroundSync:get_ValueByKye(kLoginID) noteID:responseData[@"noteId"] noteName:_crteObj.noteName isDeleted:responseData[@"isDeleted"] isSynchoronization:responseData[@"isSynchronise"] fileData:@"" dateTime:@"" tempUserId:_crteObj.tempUserId keyUpdate:@"trash"];
        
    }
    else if(requestId == Request_Update_Note_Contant && [entityName isKindOfClass:[CreateNoteContentOffline class]])
    {
        
        CreateNoteContentOffline *_crteObj = (CreateNoteContentOffline *)entityName;
        
        //        [CNDataHelper CNdBUpdateMasterTableBackgroundSync:get_ValueByKye(kLoginID) noteID:_crteObj.noteCreateID noteName:_crteObj.noteName isDeleted:@"" isSynchoronization:@"1" fileData:_crteObj.content dateTime:responseData[@"updateNoteDateTime"] tempUserId:_crteObj.tempUserId keyUpdate:@"contantUpdate"];
        
        //chnage 4-2-2016
        [CNDataHelper CNdBUpdateMasterTableBackgroundSync:get_ValueByKye(kLoginID) noteID:_crteObj.noteCreateID noteName:_crteObj.noteName isDeleted:@"" isSynchoronization:@"1" fileData:_crteObj.content dateTime:_crteObj.timestamp tempUserId:_crteObj.tempUserId keyUpdate:@"contantUpdate"];
        //end
    }
}


// crete note notifiy with success
-(void)notifyRequesterAgianCreteNoteWithSucess:(NSDictionary *)responseData requestId:(int)requestId entityName:(id)entityName
{
    if(requestId == Request_Create_New_Note && [entityName isKindOfClass:[CreateTemporaryDelete class]])
    {
        
        CreateTemporaryDelete *_objCrtNewNote = (CreateTemporaryDelete *)entityName;
        
        NSLog(@"%@",responseData);
        NSString *message = nil;
        NSString *code = responseData[@"ResponseCode"];
        message = responseData[@"ResponseDetails"];
        if([code isEqualToString:@"200"])
        {
            [CNDataHelper CNdBUpdateMasterTableBackgroundSync:get_ValueByKye(kLoginID) noteID:responseData[@"noteId"] noteName:responseData[@"Notetitle"] isDeleted:responseData[@"isDeleted"] isSynchoronization:responseData[@"isSynchronise"] fileData:responseData[@"content"] dateTime:responseData[@"Notecreatedtime"] tempUserId:_objCrtNewNote.tempUserId keyUpdate:@"masterCreateNoteUpdate"];
            
        }
        
        
        
        
        // delte the value for local db
        [[app managedObjectContext] deleteObject:_objCrtNewNote];
        NSError * error = nil;
        if (![[app managedObjectContext] save:&error])
        {
            NSLog(@"Error ! %@", error);
        }
        [[CNAddBackgroundOparation sharedInstance] AddBackgroundProcess];
        
        
    }
    
    
    if(requestId == Request_Create_New_Note && [entityName isKindOfClass:[CreatePermanentDelete class]])
    {
        
        CreatePermanentDelete *_objCrtNewNote = (CreatePermanentDelete *)entityName;
        
        NSLog(@"%@",responseData);
        NSString *message = nil;
        NSString *code = responseData[@"ResponseCode"];
        message = responseData[@"ResponseDetails"];
        if([code isEqualToString:@"200"])
        {
            [CNDataHelper CNdBUpdateMasterTableBackgroundSync:get_ValueByKye(kLoginID) noteID:responseData[@"noteId"] noteName:responseData[@"Notetitle"] isDeleted:responseData[@"isDeleted"] isSynchoronization:responseData[@"isSynchronise"] fileData:responseData[@"content"] dateTime:responseData[@"Notecreatedtime"] tempUserId:_objCrtNewNote.tempUserId keyUpdate:@"masterCreateNoteUpdate"];
            
        }
        // delte the value for local db
        [[app managedObjectContext] deleteObject:_objCrtNewNote];
        NSError * error = nil;
        if (![[app managedObjectContext] save:&error])
        {
            NSLog(@"Error ! %@", error);
        }
        [[CNAddBackgroundOparation sharedInstance] AddBackgroundProcess];
        
        
    }
    
    if(requestId == Request_Create_New_Note && [entityName isKindOfClass:[CreateRestoreOfline class]])
    {
        
        CreateRestoreOfline *_objCrtNewNote = (CreateRestoreOfline *)entityName;
        
        NSLog(@"%@",responseData);
        NSString *message = nil;
        NSString *code = responseData[@"ResponseCode"];
        message = responseData[@"ResponseDetails"];
        if([code isEqualToString:@"200"])
        {
            [CNDataHelper CNdBUpdateMasterTableBackgroundSync:get_ValueByKye(kLoginID) noteID:responseData[@"noteId"] noteName:responseData[@"Notetitle"] isDeleted:responseData[@"isDeleted"] isSynchoronization:responseData[@"isSynchronise"] fileData:responseData[@"content"] dateTime:responseData[@"Notecreatedtime"] tempUserId:_objCrtNewNote.tempUserId keyUpdate:@"masterCreateNoteUpdate"];
            
        }
        // delte the value for local db
        [[app managedObjectContext] deleteObject:_objCrtNewNote];
        NSError * error = nil;
        if (![[app managedObjectContext] save:&error])
        {
            NSLog(@"Error ! %@", error);
        }
        [[CNAddBackgroundOparation sharedInstance] AddBackgroundProcess];
        
        
    }
    
    
    if(requestId == Request_Create_New_Note && [entityName isKindOfClass:[CreateNoteContentOffline class]])
    {
        
        CreateNoteContentOffline *_objCrtNewNote = (CreateNoteContentOffline *)entityName;
        
        NSLog(@"%@",responseData);
        NSString *message = nil;
        NSString *code = responseData[@"ResponseCode"];
        message = responseData[@"ResponseDetails"];
        if([code isEqualToString:@"200"])
        {
            [CNDataHelper CNdBUpdateMasterTableBackgroundSync:get_ValueByKye(kLoginID) noteID:responseData[@"noteId"] noteName:responseData[@"Notetitle"] isDeleted:responseData[@"isDeleted"] isSynchoronization:responseData[@"isSynchronise"] fileData:responseData[@"content"] dateTime:responseData[@"Notecreatedtime"] tempUserId:_objCrtNewNote.tempUserId keyUpdate:@"masterCreateNoteUpdate"];
            
        }
        // delte the value for local db
        [[app managedObjectContext] deleteObject:_objCrtNewNote];
        NSError * error = nil;
        if (![[app managedObjectContext] save:&error])
        {
            NSLog(@"Error ! %@", error);
        }
        [[CNAddBackgroundOparation sharedInstance] AddBackgroundProcess];
        
        
    }
    
    
    
}



@end
