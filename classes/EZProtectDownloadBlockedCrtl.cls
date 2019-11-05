/**
 * @Author Adaptus / Developer - Ksolves
 * @Date 2019
 * This class will acts as the controller for the EZProtectDownloadBlocked page and Component.
 */

public  without sharing class EZProtectDownloadBlockedCrtl {
    /*File Download block type*/
    public string blockType { get; set; }
    
    /* Title of Page */    
    public string title { get; set; }

    /* Body of Page */    
    public string body { get; set; }
    
    public EZProtectDownloadBlockedCrtl(){
        blockType = ApexPages.currentPage().getParameters().get('type');
        
        if(blockType == 'Dirty'){
            title = Label.EZProtect_Dirty_File_Blocked_Title;
            body = Label.EZProtect_Dirty_File_Blocked_Body;
        }else if(blockType == 'Pending'){
            title = Label.EZProtect_Pending_File_Title;
            body = Label.EZProtect_Pending_File_Body;
        }
    }
    
     /* 
     * @description This method will used the get the file download block message from custom label.
	 * @return Map of block messages as title and body
     */
    @auraEnabled
    public static Map<String, String> getBlockMessage(String type){
        Map<String, String> blockMessages = new Map<String, String>();
        if(type == 'Dirty'){
            blockMessages.put('title', Label.EZProtect_Dirty_File_Blocked_Title);
            blockMessages.put('body', Label.EZProtect_Dirty_File_Blocked_Body);
        }else if(type == 'Pending'){
            blockMessages.put('title', Label.EZProtect_Pending_File_Title);
            blockMessages.put('body', Label.EZProtect_Pending_File_Body);
        }
        
        return blockMessages;
    }
}