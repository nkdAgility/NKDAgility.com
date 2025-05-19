---
title: "Frágil por Diseño: El Costo de Fingir Resiliencia"
description: Explora cómo la mala ingeniería, el pensamiento superficial de producto y la negación organizacional conducen a sistemas frágiles, destacando que la verdadera resiliencia requiere pruebas rigurosas en condiciones reales.
ResourceId: LGGuvRq4g7p
ResourceImport: false
ResourceType: blog
ResourceContentOrigin: hybrid
date: 2025-05-12T09:00:00Z
weight: 165
aliases:
  - /es/resources/LGGuvRq4g7p
categories:
  - Engineering Excellence
  - Product Development
  - Technical Leadership
tags:
  - Technical Mastery
  - Pragmatic Thinking
  - Engineering Practices
  - Site Reliability Engineering
Watermarks:
  description: 2025-05-07T12:49:09Z
concepts: []
---

La mayoría de los sistemas no son resilientes. Son frágiles por diseño, sostenidos por la fantasía de una “continuidad” que desaparece en cuanto se enfrenta a presión real.

El apagón nacional en España. Las fallas en cascada en Portugal. La caída del servicio en la nube hospitalaria de Oracle. El colapso catastrófico en Heathrow. No fueron accidentes. No fueron eventos raros ni impredecibles. Fueron las consecuencias inevitables de una mala ingeniería, pensamiento superficial de producto y una autoilusión organizacional.

La resiliencia no es una casilla que se marca. No es un ejercicio de cumplimiento. No es un deseo archivado en un plan de recuperación ante desastres. La resiliencia es difícil. Es costosa. Debe diseñarse, probarse y verificarse en condiciones reales. De lo contrario, no existe.

## Mala Ingeniería

La resiliencia real asume que todo fallará. Las redes fallarán. Los sistemas de autenticación fallarán. Las personas cometerán errores. Si tu arquitectura no asume fallos en todos los niveles, no eres resiliente, eres quebradizo.

La red eléctrica española colapsó porque fue optimizada para la eficiencia, no para la supervivencia. Sin redireccionamiento dinámico. Sin aislamiento de carga real. Sin observabilidad significativa. Estaba diseñada para condiciones perfectas que solo existen en las diapositivas de PowerPoint.

El fallo de Oracle fue aún peor. Sistemas críticos de salud se cayeron porque su infraestructura cloud no tenía conmutación efectiva entre regiones. Su arquitectura no se degradó con gracia, simplemente colapsó. Eso no es resiliencia, eso es negligencia a escala.

## Pensamiento de Producto y Continuidad Deficientes

La resiliencia es una **capacidad del producto**. Si tu producto no sobrevive a un fallo, no es un producto. Es un pasivo.

España, Portugal y Oracle trataron la continuidad como un añadido. Mientras las luces estuvieran encendidas hoy, todo se consideraba bien. Hasta que dejó de estarlo.

El liderazgo real de producto exige preguntas más difíciles: _¿Cuándo —no si— esta parte falle, cómo se recuperará nuestro sistema? ¿Cómo lo vivirán nuestros clientes? ¿Qué tan rápido podemos restaurar el servicio? ¿Cuánto riesgo estamos asumiendo—y ese riesgo es aceptable?_

Si estas preguntas no están presentes en tu hoja de ruta, en tu arquitectura y en tu estrategia operativa, no estás construyendo resiliencia. Estás construyendo un castillo de naipes.

## Ceguera Organizacional

El verdadero fallo está más arriba. El liderazgo falló en crear una cultura que priorizara la supervivencia operativa sobre la fantasía operativa.

Lo he vivido en carne propia. En Merrill Lynch participé en dos simulacros de recuperación ante desastres. Ambos fueron declarados “exitosos”. Ambos fueron fracasos totales.

Ningún sistema restaurado era usable. Técnicamente “estaban en línea” —funcionalmente, nada funcionaba. Y la causa raíz era obvia: Active Directory, el sistema del que dependía todo para autenticarse, nunca se recuperó. Sin él, todos los sistemas “restaurados” eran peso muerto.

Irónicamente, mi aplicación sí fue restaurada. Asumimos que hubiera sido usable —_si_ Active Directory hubiese estado disponible. Pero nunca lo supimos. Dos años seguidos, la misma dependencia crítica siguió rota y nadie quiso llamarlo como era: fallo sistémico disfrazado por métricas falsas de éxito.

El aeropuerto de Heathrow ofrece otro caso de libro. Cuando se incendió una subestación, culparon públicamente al proveedor de energía. Pero omitieron un detalle crítico: Heathrow tiene tres subestaciones independientes, cualquiera de las cuales puede alimentar todo el aeropuerto por sí sola.

El problema no fue la falta de energía, sino una fluctuación. Fue el sistema de recuperación del propio Heathrow, diseñado para “proteger” infraestructura, el que detectó esa fluctuación y apagó todo.

¿El resultado? El backbone de TI colapsó. Tomó el resto del día restaurar servicios básicos —y mucho más en recuperar el caos operativo que siguió.

En lugar de asumir el fallo interno, el liderazgo señaló hacia afuera. La misma historia de siempre: negarse a aceptar que su falsa resiliencia empeoró el desastre.

## Resiliencia Real: Iterar Sobre el Dolor

No todas las historias terminan en fracaso. Hay organizaciones que lo hacen bien —y la diferencia es la disciplina.

Caso: Rackspace. Durante inundaciones catastróficas en Londres, casi todos los datacenters fallaron, menos Rackspace. Sus generadores de respaldo funcionaron tal como se esperaba. Mientras otros culpaban proveedores, Rackspace mantuvo a sus clientes en línea.

¿Su secreto? El CEO mostró una llave.

Era la llave de la sala de energía.

Cada mes, sin falta, bajaba, abría el interruptor principal y lo bajaba —cortando la energía externa. No en teoría. No en simulación. Una transferencia real al sistema de respaldo, bajo condiciones reales.

Gracias a esa brutal disciplina, no esperaban que su plan de recuperación funcionara. Lo _sabían_. Lo habían probado, una y otra vez. Iteraron sobre el dolor.

Y esa es la lección:
Si algo es difícil, hazlo _más seguido_, no menos.
Si el fallo duele, _enfréntalo_, no lo evites.

Solo enfrentando fallos intencionales, frecuentes y controlados puedes construir resiliencia verdadera.

No puedes esperar hasta que importe. No puedes preparar solo sobre papel. Debes _ganarte_ la resiliencia exponiendo tus debilidades y recibiendo golpes hasta que seas lo suficientemente fuerte para sobrevivir al real.

## La Resiliencia se Construye, No se Compra

No puedes comprar resiliencia. No viene con tu proveedor cloud. No puedes declararte resiliente porque lo escribiste en tu plan de contingencia.

La resiliencia real se diseña. Se construye. Se prueba. Se itera. Es lenta, costosa y dolorosa. Pero la alternativa —la fragilidad que vimos en España, Portugal, Oracle y Heathrow— es mucho más cara.

Si no estás diseñando para el fallo, estás diseñando para el colapso.

La fragilidad no es un accidente. Es una decisión de diseño.
Pretender lo contrario solo garantiza que aprenderás por las malas.
