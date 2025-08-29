from typing import Union, Tuple, List, Dict
from llava.json_fixer import JSONReturnType

def fix_based_on_description(json_output, description) -> Union[JSONReturnType, Tuple[JSONReturnType, List[Dict[str, str]]]]:
    upper_to_fix = None
    if json_output.get('upperbody_garment', None): 
        upper_to_fix = 'upperbody_garment'
    elif json_output.get('wholebody_garment', None):
        upper_to_fix = 'wholebody_garment'
    if upper_to_fix:
        neck_to_fix = description[upper_to_fix]['geometry_styles'].get('neck', [])
        if len(neck_to_fix) < 1 or neck_to_fix[0].startswith(('no', 'null')):
            pass
        else:
            json_output[upper_to_fix]['collar']['f_collar'] = neck_to_fix[0]
            json_output[upper_to_fix]['collar']['b_collar'] = neck_to_fix[0]
            
        collar_to_fix = description[upper_to_fix]['geometry_styles'].get('collar', [])
        if len(collar_to_fix) < 1 or collar_to_fix[0].startswith(('no', 'null')):
            json_output[upper_to_fix]['collar']['component']['style'] = None
        else:
            json_output[upper_to_fix]['collar']['component']['style'] = collar_to_fix[0]
            
        cuff_to_fix = description[upper_to_fix]['geometry_styles'].get('cuff', [])
        if len(cuff_to_fix) < 1 or cuff_to_fix[0].startswith(('no cuff', 'null')):
            json_output[upper_to_fix]['sleeve']['cuff']['type'] = None
        elif cuff_to_fix[0].startswith(('long cuffs', 'normal cuffs')):
            json_output[upper_to_fix]['sleeve']['cuff']['type'] = 'CuffBand'
        else:
            json_output[upper_to_fix]['sleeve']['cuff']['type'] = cuff_to_fix[0]
          
    
    return json_output