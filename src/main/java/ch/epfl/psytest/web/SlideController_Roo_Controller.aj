// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package ch.epfl.psytest.web;

import ch.epfl.psytest.domain.Slide;
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

privileged aspect SlideController_Roo_Controller {
    
    @RequestMapping(params = "form", method = RequestMethod.GET)
    public String SlideController.createForm(Model uiModel) {
        uiModel.addAttribute("slide", new Slide());
        return "slides/create";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.GET)
    public String SlideController.show(@PathVariable("id") Long id, Model uiModel) {
        uiModel.addAttribute("slide", Slide.findSlide(id));
        uiModel.addAttribute("itemId", id);
        return "slides/show";
    }
    
    @RequestMapping(method = RequestMethod.GET)
    public String SlideController.list(@RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        if (page != null || size != null) {
            int sizeNo = size == null ? 10 : size.intValue();
            uiModel.addAttribute("slides", Slide.findSlideEntries(page == null ? 0 : (page.intValue() - 1) * sizeNo, sizeNo));
            float nrOfPages = (float) Slide.countSlides() / sizeNo;
            uiModel.addAttribute("maxPages", (int) ((nrOfPages > (int) nrOfPages || nrOfPages == 0.0) ? nrOfPages + 1 : nrOfPages));
        } else {
            uiModel.addAttribute("slides", Slide.findAllSlides());
        }
        return "slides/list";
    }
    
    @RequestMapping(method = RequestMethod.PUT)
    public String SlideController.update(@Valid Slide slide, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            uiModel.addAttribute("slide", slide);
            return "slides/update";
        }
        uiModel.asMap().clear();
        slide.merge();
        return "redirect:/slides/" + encodeUrlPathSegment(slide.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(value = "/{id}", params = "form", method = RequestMethod.GET)
    public String SlideController.updateForm(@PathVariable("id") Long id, Model uiModel) {
        uiModel.addAttribute("slide", Slide.findSlide(id));
        return "slides/update";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
    public String SlideController.delete(@PathVariable("id") Long id, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        Slide.findSlide(id).remove();
        uiModel.asMap().clear();
        uiModel.addAttribute("page", (page == null) ? "1" : page.toString());
        uiModel.addAttribute("size", (size == null) ? "10" : size.toString());
        return "redirect:/slides";
    }
    
    @ModelAttribute("slides")
    public Collection<Slide> SlideController.populateSlides() {
        return Slide.findAllSlides();
    }
    
}
