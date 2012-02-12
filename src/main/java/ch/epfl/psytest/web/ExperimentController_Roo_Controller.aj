// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package ch.epfl.psytest.web;

import ch.epfl.psytest.domain.Experiment;
import ch.epfl.psytest.domain.ExperimentSession;
import java.io.UnsupportedEncodingException;
import java.lang.Integer;
import java.lang.Long;
import java.lang.String;
import java.util.Collection;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.util.UriUtils;
import org.springframework.web.util.WebUtils;

privileged aspect ExperimentController_Roo_Controller {
    
    @RequestMapping(params = "form", method = RequestMethod.GET)
    public String ExperimentController.createForm(Model uiModel) {
        uiModel.addAttribute("experiment", new Experiment());
        return "experiments/create";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.GET)
    public String ExperimentController.show(@PathVariable("id") Long id, Model uiModel) {
        uiModel.addAttribute("experiment", Experiment.findExperiment(id));
        uiModel.addAttribute("itemId", id);
        return "experiments/show";
    }
    
    @RequestMapping(method = RequestMethod.GET)
    public String ExperimentController.list(@RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        if (page != null || size != null) {
            int sizeNo = size == null ? 10 : size.intValue();
            uiModel.addAttribute("experiments", Experiment.findExperimentEntries(page == null ? 0 : (page.intValue() - 1) * sizeNo, sizeNo));
            float nrOfPages = (float) Experiment.countExperiments() / sizeNo;
            uiModel.addAttribute("maxPages", (int) ((nrOfPages > (int) nrOfPages || nrOfPages == 0.0) ? nrOfPages + 1 : nrOfPages));
        } else {
            uiModel.addAttribute("experiments", Experiment.findAllExperiments());
        }
        return "experiments/list";
    }
    
    @RequestMapping(method = RequestMethod.PUT)
    public String ExperimentController.update(@Valid Experiment experiment, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            uiModel.addAttribute("experiment", experiment);
            return "experiments/update";
        }
        uiModel.asMap().clear();
        experiment.merge();
        return "redirect:/experiments/" + encodeUrlPathSegment(experiment.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(value = "/{id}", params = "form", method = RequestMethod.GET)
    public String ExperimentController.updateForm(@PathVariable("id") Long id, Model uiModel) {
        uiModel.addAttribute("experiment", Experiment.findExperiment(id));
        return "experiments/update";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
    public String ExperimentController.delete(@PathVariable("id") Long id, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        Experiment.findExperiment(id).remove();
        uiModel.asMap().clear();
        uiModel.addAttribute("page", (page == null) ? "1" : page.toString());
        uiModel.addAttribute("size", (size == null) ? "10" : size.toString());
        return "redirect:/experiments";
    }
    
    @ModelAttribute("experiments")
    public Collection<Experiment> ExperimentController.populateExperiments() {
        return Experiment.findAllExperiments();
    }
    
    @ModelAttribute("experimentsessions")
    public Collection<ExperimentSession> ExperimentController.populateExperimentSessions() {
        return ExperimentSession.findAllExperimentSessions();
    }
    
    String ExperimentController.encodeUrlPathSegment(String pathSegment, HttpServletRequest httpServletRequest) {
        String enc = httpServletRequest.getCharacterEncoding();
        if (enc == null) {
            enc = WebUtils.DEFAULT_CHARACTER_ENCODING;
        }
        try {
            pathSegment = UriUtils.encodePathSegment(pathSegment, enc);
        }
        catch (UnsupportedEncodingException uee) {}
        return pathSegment;
    }
    
}
