package com.alphathur.demo.model;


import lombok.Data;

import javax.persistence.*;
import java.util.Date;

@Entity
@Data
public class Student {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private String name;

    private Integer age;

    private char gender;

    private String parent;

    @Temporal(TemporalType.DATE)
    private Date birth;
}
