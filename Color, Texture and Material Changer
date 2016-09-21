//This nPose plugin script is licensed under the GPLv3
//Author Zero Upshaw
//This script is based roughly on a script by howard braxton

list savedParms;
integer arbNum = -22452987;
integer DOPOSE = 200;
integer CORERELAY = 300;


manageStrideList(vector col, integer sideNo, string str, key tex, string type){
    integer d = llListFindList(savedParms,[str]);
    if (d != -1)  {
        savedParms = llDeleteSubList(savedParms, d - 3, d + 1);
    }
    savedParms = [llList2CSV([col,sideNo,str,tex,type])] + savedParms;
}
integer fncStrideCount(list lstSource, integer intStride){
  return llGetListLength(lstSource) / intStride;
}
list fncGetStride(list lstSource, integer intIndex, integer intStride){
  integer intNumStrides = fncStrideCount(lstSource, intStride);
  if (intNumStrides != 0 && intIndex < intNumStrides)
  {
    integer intOffset = intIndex * intStride;
    return llList2List(lstSource, intOffset, intOffset + (intStride - 1));
  }
  return [];
}


default
{
    link_message(integer sender_num, integer num, string str, key id){
        key texture;
        key normal;
        key specular;
         if (num==arbNum){
            list params = llParseString2List(str, ["~"], []);
            integer sides = (integer)llList2String(params, 1);
            string textureWho = llList2String(params, 2);
            vector color = (vector)llList2String(params, 0);
            string texture_type = llList2String(params,3);
            manageStrideList(color,sides,textureWho,id,texture_type);                    
        }if (num==arbNum || num == arbNum+1){
            llRegionSay(num, "LINKMSG|"+(string)num+"|"+str+"|"+(string)id);
            if (llGetInventoryNumber(INVENTORY_TEXTURE)>0){
                integer i;
                for(; i<llGetInventoryNumber(INVENTORY_TEXTURE); ++i){
                    if (llGetInventoryName(INVENTORY_TEXTURE, i) == (string)id){
                        id = llGetInventoryKey(llGetInventoryName(INVENTORY_TEXTURE, i));
                    }
                }
            }
            list params = llParseString2List(str, ["~"], []);
            integer sides = (integer)llList2String(params, 1);
            string textureWho = llList2String(params, 2);
            vector color = (vector)llList2String(params, 0);
            string texture_type = llList2String(params,3);
            integer n;
            if(texture_type == "normal"){
                normal = id;
                texture = specular = NULL_KEY;
            }else if(texture_type == "specular"){
                specular = id;
                normal = texture = NULL_KEY;
            }else{
                texture = id;
                normal = specular = NULL_KEY;
            }
            integer linkcount = llGetNumberOfPrims();
            for (n = 1; n <= linkcount; n++) {
                string desc = (string)llGetObjectDetails(llGetLinkKey(n), [OBJECT_DESC]);
                list params1 = llParseString2List(desc, ["~"], []);
                if (llList2String(params1, 0) == textureWho){
                    if(texture != NULL_KEY){
                        llSetLinkPrimitiveParamsFast(n,[PRIM_TEXTURE, sides, texture]);
                    }if(normal != NULL_KEY){
                        llSetLinkPrimitiveParamsFast(n,[PRIM_NORMAL, sides, normal]);
                    }if(specular != NULL_KEY){
                        llSetLinkPrimitiveParamsFast(n,[PRIM_SPECULAR, sides, specular]);
                    }
                    llSetLinkPrimitiveParamsFast(n,[PRIM_COLOR, sides, color]);
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
                string texture_type = llList2String(thisSet,4);
                key savedid = (key)llList2String(thisSet,3);
                string myString = (string)color+"~"+(string)sides+"~"+textureWho+"~"+texture_type;
                llSleep(5);
                llMessageLinked(LINK_SET,CORERELAY,llDumpList2String([(arbNum+1), myString,savedid],"|"),NULL_KEY);
            }
        }
    }
 }

