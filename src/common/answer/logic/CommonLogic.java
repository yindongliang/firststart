/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package common.answer.logic;


import common.answer.logic.helper.PopertiesHelper;
import java.util.List;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 *
 * @author doyin
 */
@Service(value = "CommonLogic")
public class CommonLogic {

    @Autowired
    protected PopertiesHelper popertiesHelper = null;
    private static Logger log = Logger.getLogger(CommonLogic.class);
    List<String> ls_shsz = null;

    public List<String> getLs_shsz(String datafile_path_sh,String datafile_path_sz) {
        ls_shsz = popertiesHelper.getStockCds( datafile_path_sh, datafile_path_sz);
        return ls_shsz;
    }
}
