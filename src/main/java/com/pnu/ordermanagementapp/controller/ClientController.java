package com.pnu.ordermanagementapp.controller;

import com.pnu.ordermanagementapp.service.ClientService;
import com.pnu.ordermanagementapp.model.Client;
import com.pnu.ordermanagementapp.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/clients")
public class ClientController {

    private ClientService clientService;

    @Autowired
    public ClientController(ClientService clientService) {
        this.clientService = clientService;
    }

    @GetMapping
    public String getAll(@RequestParam(name = "page", required = false, defaultValue = "1") Integer page,
                         @RequestParam(name = "active", required = false, defaultValue = "true") boolean isActive,
                         Model model, @AuthenticationPrincipal User user) {
        model.addAttribute("active", isActive);
        model.addAttribute("clients", clientService.findAllByActivity(page, isActive, user.getId()));
        return "client/show_clients";
    }

    @GetMapping("/find")
    public String getAllByName(@RequestParam(name = "page", required = false, defaultValue = "1") Integer page,
                               @RequestParam(name = "active", required = false, defaultValue = "true") boolean isActive,
                               @RequestParam("q") String nameQuery, Model model, @AuthenticationPrincipal User user) {
        model.addAttribute("active", isActive);
        model.addAttribute("nameQuery", nameQuery);
        model.addAttribute("clients", clientService.findAllByNameAndActivity(page, nameQuery, isActive, user.getId()));
        return "client/show_clients";
    }

    @GetMapping("/new")
    public String create() {
        return "client/create_form";
    }

    @GetMapping("/update/{id}")
    public String update(@PathVariable Long id, Model model, @AuthenticationPrincipal User user) {
        model.addAttribute("client", clientService.findById(id, user.getId()));
        return "client/update_form";
    }

    @PostMapping("/new")
    public String createClient(@ModelAttribute Client client, @AuthenticationPrincipal User user) {
        clientService.create(client, user.getId());
        return "redirect:/clients";
    }

    @PostMapping("/update")
    public String updateClient(@ModelAttribute Client client, @AuthenticationPrincipal User user) {
        clientService.update(client, user.getId());
        return "redirect:/clients";
    }

    @PostMapping("/delete/{id}")
    public String deleteClient(@PathVariable Long id, @AuthenticationPrincipal User user) {
        clientService.delete(id, user.getId());
        return "redirect:/clients";
    }

    @PostMapping("/activate/{id}")
    public String activateClient(@PathVariable("id") Long id, @AuthenticationPrincipal User user) {
        clientService.activate(id, user.getId());
        return "redirect:/clients";
    }

}