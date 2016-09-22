//This nPose plugin script is licensed under the GPLv3
//Author Zero Upshaw
//This script is based roughly on a script by howard braxton

list savedParms;
integer arbNum = -22452987;
integer DOPOSE = 200;
integer CORERELAY = 300;
list obj_p;  
vector rep;
vector off;
float rot;
integer glos;
integer env;
string texture_type;


manageStrideList(vector col, integer sideNo, string str, key tex, string type){
    integer d = llListFindList(savedParms,[str]);
    if (d != -1)  {
        savedParms = llDeleteSubList(savedParms, d - 3, d + 1);
    }
    savedParms = [llList2CSV([col,sideNo,str,tex,type])] + savedParms;
}

get_prim_props(integer n, integer sides){
    if(texture_type == "texture"){
        list obj_p = llGetLinkPrimitiveParams(n,[PRIM_TEXTURE,sides]);       
        rep = llList2Vector(obj_p,1);
        off = llList2Vector(obj_p,2);
        rot = llList2Float(obj_p,4);
    }else if(texture_type == "normal"){
        list obj_p = llGetLinkPrimitiveParams(n,[PRIM_NORMAL,sides]);       
        rep = llList2Vector(obj_p,1);
        off = llList2Vector(obj_p,2);
        rot = llList2Float(obj_p,4);
    }else if(texture_type == "specular"){
        list obj_p = llGetLinkPrimitiveParams(n,[PRIM_SPECULAR,sides]);       
        rep = llList2Vector(obj_p,1);
        off = llList2Vector(obj_p,2);
        rot = llList2Float(obj_p,4);
        glos = llList2Integer(obj_p,5);
        env = llList2Integer(obj_p,6);
    }
}


default
{
    link_message(integer sender_num, integer num, string str, key id){
         if (num==arbNum){
            list params = llParseString2List(str, ["~"], []);
            integer sides = (integer)llList2String(params, 1);
            string textureWho = llList2String(params, 2);
            vector color = (vector)llList2String(params, 0);
            texture_type = llList2String(params,3);                  
        }if (num==arbNum || num == arbNum+1){
            llRegionSay(num, "LINKMSG|"+(string)num+"|"+str+"|"+(string)id);
            //llOwnerSay("get texture");
            
            if (llGetInventoryNumber(INVENTORY_TEXTURE)>0){
                integer i;
                for(; i<llGetInventoryNumber(INVENTORY_TEXTURE); ++i){
                    if (llGetInventoryName(INVENTORY_TEXTURE, i) == (string)id){
                        id = llGetInventoryKey(llGetInventoryName(INVENTORY_TEXTURE, i));
                    }
                }
            }
            //llOwnerSay("Getting Params: " + str);
            list params = llParseString2List(str, ["~"], []);
            integer sides = (integer)llList2String(params, 1);
            string textureWho = llList2String(params, 2);
            vector color = (vector)llList2String(params, 0);
            texture_type = llList2String(params,3);
            integer n;
            integer linkcount = llGetNumberOfPrims();
            for (n = 0; n <= linkcount; n++) {
                string desc = (string)llGetObjectDetails(llGetLinkKey(n), [OBJECT_DESC]);
                list params1 = llParseString2List(desc, ["~"], []);
                get_prim_props(n,sides);
                if(id == ""){
                    id = NULL_KEY;
                }
                if (llList2String(params1, 0) == textureWho){
                    if(id != NULL_KEY){
                        if(texture_type == "texture" || texture_type == ""){
                            llSetLinkPrimitiveParamsFast(n,[PRIM_TEXTURE, sides, id, rep, off, rot]);
                        }else if(texture_type == "normal"){
                            llSetLinkPrimitiveParamsFast(n,[PRIM_NORMAL, sides, id, rep, off, rot]);
                        }else if(texture_type == "specular"){
                            llSetLinkPrimitiveParamsFast(n,[PRIM_SPECULAR, sides, id, rep, off, rot, color, glos, env]);
                        }
                    }
                    llSetLinkPrimitiveParamsFast(n,[PRIM_COLOR, sides, color, llGetAlpha(sides)]);
                }
            }
        }
        if (num == DOPOSE)
        {
            integer stridesNo = llGetListLength(savedParms);
            integer a;
            for (a = 0; a <= stridesNo-1; a++){
                list thisSet = llCSV2List(llList2String(savedParms,a));
                vector color = (vector)llList2String(thisSet, 0);
                integer sides = (integer)llList2String(thisSet, 1);
                string textureWho = llList2String(thisSet, 2);
                texture_type = llList2String(thisSet,4);
                key savedid = (key)llList2String(thisSet,3);
                string myString = (string)color+"~"+(string)sides+"~"+textureWho+"~"+texture_type;
                llSleep(5);
                llMessageLinked(LINK_SET,CORERELAY,llDumpList2String([(arbNum+1), myString,savedid],"|"),NULL_KEY);
            }
        }
    }
 }

