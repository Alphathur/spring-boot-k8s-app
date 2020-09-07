package com.alphathur.demo.web;

import com.alphathur.demo.model.Student;
import com.alphathur.demo.repository.StudentRepository;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("students")
public class StudentController {

    private final StudentRepository studentRepository;

    public StudentController(StudentRepository studentRepository) {
        this.studentRepository = studentRepository;
    }

    @GetMapping
    public List<Student> viewAll() {
        return studentRepository.findAll();
    }

    @PostMapping
    public Student saveOne(@RequestBody Student student) {
        return studentRepository.save ( student );
    }

    @GetMapping("{id}")
    public Student findOne(@PathVariable Integer id){
        return studentRepository.findById ( id ).orElse ( null );
    }

    @DeleteMapping("{id}")
    public String deleteOne(@PathVariable Integer id){
        studentRepository.deleteById ( id );
        return "ok";
    }
}
